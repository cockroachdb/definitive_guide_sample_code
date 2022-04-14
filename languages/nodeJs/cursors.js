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
    Using the pg-cursor module */
    
const pg = require('pg');
const Cursor = require('pg-cursor');



async function main() {
    try {
        // Check parameters

        if (process.argv.length != 3) {
            console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
            process.exit(1);
        }
        const connectionString = process.argv[2];
        const pool = new pg.Pool({
            connectionString
        });
        // const connection = await pool.connect();
        const connection = new pg.Client(connectionString);
        await connection.connect();


        await connection.query('USE chapter06');
        await connection.query('set tracing=on');
        // await traceStats(connection);
        const sql = `SELECT post_timestamp, summary 
                   FROM blog_posts ORDER BY post_timestamp DESC`;
        // let rows=await connection.query(sql);
        let startTime = new Date();
        const data = await connection.query(sql);
        for (let i = 0; i < 10; i++) {
            console.log(data.rows[i]);
        }
        console.log((new Date() - startTime));

        /* let cursor = await connection.query(new Cursor(sql));
        console.log('1');
        console.log(await cursorRead(cursor, 10));
        console.log('2');
        console.log(await cursorRead(cursor, 10));
        console.log('4');
        console.log(await cursorRead(cursor, 10));

        const rows = await cursor.read(100);
        console.log(rows);
        // console.log(cursor);
        // console.log(Object.keys(cursor));* */

        startTime = new Date();
        const cursor = await connection.query(new Cursor(sql));
        // await traceStats(connection);

        cursor.read(10, (err, rows) => {
            console.log(rows);
            console.log('cursor', (new Date() - startTime));
            if (err) {
                throw err;
            }
        });
        console.log('done');
        await traceStats(connection);
    } catch (error) {
        console.error(error.stack);
    }
    // process.exit(0);
}

function cursorRead(cursor, batchSize) {
    return new Promise((resolve, reject) => {
        cursor.read(batchSize, async (err, rows) => {
            if (err) {
                reject(err);
            }
            resolve(rows);
        });
    });
}

async function traceStats(connection) {
    let sql = `SELECT age , message
                    FROM [SHOW TRACE FOR SESSION]
                    WHERE message LIKE 'query cache miss'
                    OR message LIKE 'rows affected%'
                    OR message LIKE '%executing PrepareStmt%'
                    OR message LIKE 'executing:%'
                    ORDER BY age`;
    sql = 'show trace for session';
    console.log(sql);
    const data = await connection.query(sql);
    console.log(data.rows);
    await connection.query('set tracing=on');
}

main();
