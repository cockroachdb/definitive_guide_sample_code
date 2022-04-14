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

@author:  gharriso (github.com/gharriso)
*/

/* 
    This sample was used to benchmark the use of bind variables
    (query parameters) in various circumstances */

const CrClient = require('pg').Client;
 // load pg client
let debug = false;
const maxKey = 1000000;

async function main() {
    try {
        // Check parameters
        if (process.argv.length != 5) {
            console.log('Usage: node pkTest.js nConnections nFetches CONNECTION_URI');
            process.exit(1);
        }
        // Establish a connection using the command line URI
        const nConnections = process.argv[2];
        const nFetches = process.argv[3];
        const connectionString = process.argv[4];
        const connections = [];
        for (let ci = 0; ci < nConnections; ci++) {
            connections[ci] = new CrClient(connectionString);
            await connections[ci].connect();
            const data = await connections[ci].query(
                `SELECT CONCAT('Hello from CockroachDB at ',
                                CAST (NOW() as STRING)) as hello`
            );
            // Print out the error message
            console.log(data.rows[0].hello);
            await connections[ci].query('use Chapter05');
        }
        let promises = [];
        let start = new Date();
        for (let ci = 0; ci < nConnections; ci++) {
            promises.push(fetchesNoBind(connections[ci], nFetches));
        }
         debug = true;
        await Promise.all(promises).then((promiseOut) => {
            if (debug) console.log(promiseOut);
        });
        console.log(((new Date()) - start), 'ms');
        start = new Date();
        promises=[];
        for (let ci = 0; ci < nConnections; ci++) {
            promises.push(fetchesBind(connections[ci], nFetches));
        }
         debug = true;
        await Promise.all(promises).then((promiseOut) => {
            if (debug) console.log(promiseOut);
        });
        console.log(((new Date()) - start), 'ms');

        start = new Date();
        promises=[];
        for (let ci = 0; ci < nConnections; ci++) {
            promises.push(fetchesNamedBind(connections[ci], nFetches));
        }
         debug = true;
        await Promise.all(promises).then((promiseOut) => {
            if (debug) console.log(promiseOut);
        });
        console.log(((new Date()) - start), 'ms');
    } catch (error) {
        console.log(error.stack);
    }
    // Exit
    process.exit(0);
}

async function fetchesNoBind(connection, nFetches) {
    let rowsFetched = 0;
    for (let ii = 0; ii < nFetches; ii += 1) {
        const id = Math.floor(Math.random() * maxKey) + 1;
        const dataOut = await connection.query('SELECT * FROM clustered_data where pk=' + id);
        rowsFetched += dataOut.rows.length;
    }
    return (rowsFetched);
}

async function fetchesBind(connection, nFetches) {
    let rowsFetched = 0;
    for (let ii = 0; ii < nFetches; ii += 1) {
        const id = Math.floor(Math.random() * maxKey) + 1;
        const dataOut = await connection.query('SELECT * FROM clustered_data where pk=$1', [id]);
        rowsFetched += dataOut.rows.length;
    }
    return (rowsFetched);
}

async function fetchesNamedBind(connection, nFetches) {
    let rowsFetched = 0;
    for (let ii = 0; ii < nFetches; ii += 1) {
        const id = Math.floor(Math.random() * maxKey) + 1;
        const query = {
            // give the query a unique name
            name: 'bind-test',
            text: 'SELECT * FROM clustered_data where pk=$1',
            values: [id],
          };
        const dataOut = await connection.query(query);
        rowsFetched += dataOut.rows.length;
    }
    return (rowsFetched);
}

function dataBatch(rows) {
    const data = [];
    for (let ri = 0; ri < rows; ri += 1) {
        data.push({
            pk: ri,
            id: ri,
            rnumber: Math.random(),
            rstring: Math.random().toString(36).replace(/[^a-z]+/g, '')
        });
    }
    return (data);
}

async function insertTest(connections, tableName, insertPk, data) {
    const start = new Date();
    let sqlText = `INSERT INTO ${tableName} (id,rnumber,rstring) VALUES($1,$2,$3)`;
    if (insertPk) {
        sqlText = `INSERT INTO ${tableName} (pk,id,rnumber,rstring) VALUES($1,$2,$3, $4)`;
    }

    const promises = [];

    for (let ci = 0; ci < connections.length; ci += 1) {
        promises.push(
            randQueries(connections[ci], n)
        );
    }
    await Promise.all(promises).then((promiseOut) => {
        if (debug) console.log(promiseOut);
    });

    console.log(`${data.length} rows inserted into ${tableName} in ${((new Date()) - start)} ms`);
    const rs1 = await connections[0].query(
        `SELECT COUNT(*) AS n FROM ${tableName}`
    );
    // Print out the error message
    console.log(rs1.rows[0].n, ' rows inserted');
}

async function runQueries(connection, totConnections, connectionNo, data, sqlText, insertPk) {
    for (let di = 0; di < data.length; di += 1) {
        if (di % totConnections === connectionNo) {
            const myData = data[di];
            if (insertPk) await connection.query(sqlText, [myData.pk, myData.id, myData.rnumber, myData.rstring]);
            else await connection.query(sqlText, [myData.id, myData.rnumber, myData.rstring]);
        }
    }
}

async function createTables(connection) {
    const statements = [];
    statements.push('DROP TABLE seq_keyed');
    statements.push('DROP TABLE serial_keyed');
    statements.push('DROP TABLE uuid_keyed');
    statements.push('DROP TABLE hash_keyed');
    statements.push('DROP TABLE int_keyed');
    statements.push('DROP SEQUENCE seq_seq');
    statements.push('CREATE SEQUENCE seq_seq');
    statements.push(`
    CREATE TABLE seq_keyed  (
        pk INT NOT NULL PRIMARY KEY DEFAULT nextval('seq_seq')  ,
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push(`
    CREATE TABLE serial_keyed  (
        pk SERIAL PRIMARY KEY NOT NULL  ,
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push(`
    CREATE TABLE uuid_keyed  (
        pk uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(), 
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push(`
    CREATE TABLE int_keyed  (
        pk int not null primary key,
        id int,
        rnumber float,
        rstring string
    )`);
    statements.push('SET experimental_enable_hash_sharded_indexes=on');
    statements.push(`
    CREATE TABLE hash_keyed  (
        pk int NOT NULL,
        id int,
        rnumber float,
        rstring STRING,
        PRIMARY KEY (pk) USING HASH WITH BUCKET_COUNT=6
    )`);
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
