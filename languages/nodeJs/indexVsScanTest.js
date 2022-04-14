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
    Benchmark for comparing index scans to table scans */

const CrClient = require('pg').Client;
// load pg client
const debug = false;

async function main() {
    try {
        // Check parameters
        if (process.argv.length != 4) {
            console.log('Usage: node this.js nRows CONNECTION_URI');
            process.exit(1);
        }
        // Establish a connection using the command line URI

        const nRows = process.argv[2];
        const connectionString = process.argv[3];
        const connection = new CrClient(connectionString);
        await connection.connect();


        // await createTables(connection, nRows);
        const tables = ['clustered_data',  'clustered_data@clustered_data_i1', 'clustered_data@primary', 'unclustered_data','unclustered_data@unclustered_data_i1', 'unclustered_data@primary'];
        // const tables = ['clustered_data', 'clustered_data@clustered_data_i1', 'clustered_data@primary'];
        console.log('table,pct,ms');
        for (let ti = 0; ti < tables.length; ti += 1) {
            await runTest(connection, tables[ti], nRows);
        }
    } catch (error) {
        console.log(error.stack);
    }
    // Exit
    process.exit(0);
}

async function runTest(connection, table, nRows) {
    const pcts = [0.2, 0.5, 1, 2, 3, 4, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90];
    // const pcts=[1,2,5,8,10,12,15,16,17,18,20];
    for (let pi = 0; pi < pcts.length; pi += 1) {
        const rowfilter = nRows * pcts[pi] / 100;
        const sql = `EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${table}  WHERE indcolumn< ${rowfilter}`;
        process.stderr.write(`${sql}\n`);
        const output = await connection.query(sql);
        let execTime;
        let estPct;
        for (let ri = 0; ri < output.rows.length; ri += 1) {
            const row = output.rows[ri].info;
            process.stderr.write(`${row}\n`);
            const execMatch1 = row.match(/^execution time: ([[+-]?([0-9]*[.])?[0-9]+)ms/);
            if (execMatch1) execTime = execMatch1[1];
            const execMatch2 = row.match(/^execution time: ([[+-]?([0-9]*[.])?[0-9]+)s/);
            if (execMatch2) {
                execTime = execMatch2[1] * 1000;
            }
        }
        console.log(table, ',', pcts[pi], ',', execTime);
    }
}

async function createTables(connection, nRows) {
    const statements = [];
    statements.push('DROP TABLE clustered_data');
    statements.push('DROP table unclustered_data');
    statements.push('CREATE TABLE clustered_data (pk int NOT NULL PRIMARY KEY, indColumn int NOT NULL, textData STRING, dateData date)');
    statements.push('CREATE TABLE unclustered_data (pk uuid NOT NULL PRIMARY KEY, indColumn int NOT NULL, textData STRING, dateData date)');
    statements.push(`INSERT INTO clustered_data (pk,indColumn,textData,dateData)
                    WITH RECURSIVE series AS ( SELECT 1 AS id
                    UNION ALL SELECT id + 1 AS id
                    FROM series
                    WHERE id < ${nRows} ), randoms AS ( SELECT id int_id,(random()* 10000000)::int randomInt, random() randomFloat, md5(random()::STRING) randomString ,
                        ((now()-INTERVAL '30 years')+ (ROUND(random()* 20,2) || ' years')::INTERVAL)::date randomDate
                    FROM series) 
                    SELECT int_id, int_id,randomString, randomDate
                    FROM randoms;`);
    statements.push(`INSERT INTO unclustered_data (pk,indColumn,textData,dateData)
                    SELECT gen_random_uuid(),indColumn, textData,dateData
                    FROM clustered_data`);

    statements.push('CREATE INDEX clustered_data_i1 ON clustered_data(indColumn)');
    statements.push('CREATE INDEX unclustered_data_i1 ON unclustered_data(indColumn)');
    statements.push('ANALYZE unclustered_data ');
    statements.push('ANALYZE clustered_data ');
    for (let si = 0; si < statements.length; si += 1) {
        console.log(statements[si]);
        try {
            await connection.query(statements[si]);
        } catch (error) {
            console.log(error.message, ' while executing ', statements[si]);
        }
    }
}

main();