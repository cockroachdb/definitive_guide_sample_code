/* 
CockroachDB the Definitive Guide sample code 
This code  is public domain software, i.e. not copyrighted.

Warranty Exclusion
------------------
You agree that this software is a non-commercially developed program that may 
contain "bugs"   and that it may not function as intended.
The software is licensed "as is". The authors make no, and hereby expressly
disclaim all, warranties, express, implied, statutory, or otherwise
with respect to the software, including noninfringement and the implied
warranties of merchantability and fitness for a particular purpose.

@author:  gharriso (guy.a.harrison@gmail.com)
*/

/* 
    Consuming a postgreSQL change feed in CockroachDB */
    
const pg = require('pg');
const {
    values
} = require('regenerator-runtime');


if (process.argv.length != 4) {
    console.log(`Usage: node ${process.argv[1]} pgurl crdb_url`);
    process.exit(1);
}

const pgConnection = new pg.Client(process.argv[2]);
const crdbConnection = new pg.Client(process.argv[3]);

async function main() {
    try {
        await pgConnection.connect();
        await crdbConnection.connect();

        await startReplication();
        // await copyTable();
        while (true) {
            await syncChanges();
        }
    } catch (error) {
        console.log(error.stack);
        process.exit(1);
    }
    process.exit(0);
}

async function startReplication() {
    try {
        const replicationStatus = await pgConnection.query(
            `SELECT * 
              FROM pg_create_logical_replication_slot(
                   'cockroach_migration', 'wal2json')`
        );
        console.log(replicationStatus.rows[0]);
    } catch (error) {
        console.warn(
            'Warning ', error.message
        );
    }
}

async function copyTable() {
    const pgData = await pgConnection.query('SELECT * from rental');
    for (let rowNo = 0; rowNo < pgData.rows.length; rowNo += 1) {
        const row = pgData.rows[rowNo];
        await crdbConnection.query(
            `INSERT INTO rental (rental_id,rental_date,inventory_id,
                                customer_id,return_date,staff_id,last_update)
             VALUES ($1,$2,$3,$4,$5,$6,$7)`,
            [row.rental_id, row.rental_date, row.inventory_id, row.customer_id,
                row.return_date, row.staff_id, row.last_update
            ]
        );
    }
    console.log(pgData.rows.length, ' rows copied');
}

async function syncChanges() {
    const changeSQL = await pgConnection.query(
        `SELECT * FROM pg_logical_slot_get_changes(
            'cockroach_migration', NULL, NULL)`
    );
    for (rowNo = 0; rowNo < changeSQL.rows.length; rowNo++) {
        const changePayload = changeSQL.rows[rowNo];
        await processSingleChange(changePayload);
    }
}

main();

async function processSingleChange(rawPayload) {
    const jsonPayload = JSON.parse(rawPayload.data);
    if ('change' in jsonPayload) {
        for (let cindx = 0; cindx < jsonPayload.change.length; cindx++) {
            const changeData = jsonPayload.change[cindx];
            const columnCount = changeData.columnnames.length;
            if (changeData.kind === 'insert' && changeData.table === 'rental') {
                const newValue = {}; // Object containing CDC row values
                for (let colno = 0; colno < columnCount; colno++) {
                    const columnName = changeData.columnnames[colno];
                    newValue[columnName] = changeData.columnvalues[colno];
                }
                const insertSQL = `
                       UPSERT into rental
                          (rental_id,rental_date,inventory_id,
                           customer_id,return_date,staff_id,last_update) 
                         VALUES ($1,$2,$3,$4,$5,$6,$7)`;
                const result = await crdbConnection.query(insertSQL,
                    [newValue.rental_id, newValue.rental_date,
                     newValue.inventory_id, newValue.customer_id,
                     newValue.return_date, newValue.staff_id,
                    newValue.last_update ]);
                console.log(result.rowCount, 'rows', result.command + 'ed');
            }
        }
    }
}
