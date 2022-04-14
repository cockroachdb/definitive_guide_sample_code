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
    Example of a timeseries workload and indexing dynamics */

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


        await createTables(connection, nRows);
         const tables = ['timeseries_data', 'timeseries_data@primary', 'timeseries_data@timeseries_timestamp_i1'];
        console.log('table,dayFilter,estRows,estPct,execTime');
        for (let ti = 0; ti < tables.length; ti += 1) {
            await runTest(connection, tables[ti]);
        }
        connection.query('CREATE INDEX timeseries_covering ON timeseries_data(measurement_timestamp) STORING (measurement)');
        await runTest(connection, 'timeseries_data@timeseries_covering');
    } catch (error) {
        console.log(error.stack);
    }
    // Exit
    process.exit(0);
}

async function runTest(connection, table) {
    const days = [0.5, 1, 2, 3, 4, 5, 5, 7, 8, 9, 10, 12, 14, 16, 18, 20, 30, 40, 90, 180, 270, 360];
    // const pcts=[1,2,5,8,10,12,15,16,17,18,20];
    for (let pi = 0; pi < days.length; pi += 1) {
        const dayFilter = days[pi];
        const sql = `EXPLAIN ANALYZE SELECT AVG(measurement) FROM ${table}  WHERE measurement_timestamp > ((date '20220101')- INTERVAL '${dayFilter} days')`;
        process.stderr.write(`${sql}\n`);
        const output = await connection.query(sql);
        let execTime;
        let estPct;
        let estRows;
        for (let ri = 0; ri < output.rows.length; ri += 1) {
            const row = output.rows[ri].info;
            process.stderr.write(`${row}\n`);
            const execMatch1 = row.match(/^execution time: ([[+-]?([0-9]*[.])?[0-9]+)ms/);
            if (execMatch1) execTime = execMatch1[1];
            const execMatch2 = row.match(/^execution time: ([[+-]?([0-9]*[.])?[0-9]+)s/);
            if (execMatch2) {
                execTime = execMatch2[1] * 1000;
            }
            const execMatch3 = row.match(/estimated row count: (.*) \((.*)% of the table/);
            if (execMatch3) {
                 estRows = parseInt(execMatch3[1], 10);
                 estPct = parseFloat(execMatch3[2]);
            }
        }
        console.log(`${table},${dayFilter},${estRows},${estPct},${execTime}`);
    }
}

async function createTables(connection, nRows) {
    const stmts = [];
    stmts.push('DROP TABLE IF EXISTS  timeseries_data');
    stmts.push(`
        CREATE TABLE timeseries_data
            (id uuid primary key NOT NULL PRIMARY KEY, 
            measurement_timestamp timestamp ,
            measurement float,
            metadata string)`);

    stmts.push(`
    INSERT INTO timeseries_data (id,measurement_timestamp,measurement,metadata)
            WITH RECURSIVE series AS 
                ( SELECT ${nRows} AS id
                    UNION ALL 
                SELECT id -1 AS id
                    FROM series
                    WHERE id > 0 ) 
            SELECT gen_random_uuid(),((date '20220101') -   (id||' minutes')::INTERVAL)::timestamp , random() randomFloat, md5(random()::STRING) randomString  FROM series`);

    stmts.push('CREATE INDEX timeseries_timestamp_i1 ON timeseries_data(measurement_timestamp)');
    stmts.push('ANALYZE timeseries_data');
    for (let si = 0; si < stmts.length; si += 1) {
        console.log(stmts[si]);
        try {
            await connection.query(stmts[si]);
        } catch (error) {
            console.log(error.message, ' while executing ', stmts[si]);
            throw error;
        }
    }
}

main();
