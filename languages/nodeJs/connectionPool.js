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
    Example of using NodeJS connection pools 
    */
   
const pg = require('pg');
const Cursor = require('pg-cursor');

if (process.argv.length != 3) {
    console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
    process.exit(1);
}
const connectionString = process.argv[2];

const pool = new pg.Pool({
    connectionString,
    max: 40
});
// const connection = await pool.connect();
const connection = new pg.Client(connectionString);

let city;
let userId;
let vehicleId;

async function main() {
    const debug = false;
    try {
        await connection.connect();
        // Check parameters

        await connection.query('USE movr');
        if (debug) await connection.query('set tracing=on');
        const threads = 40;
        const loops = 100;
        let promises = [];

        // Get the default vehicle id, etc
        let sql='SELECT city,id FROM public.users LIMIT 1';
        let data=await connection.query(sql);
        city=data.rows[0].city;
        userId=data.rows[0].id;
         sql='SELECT city,id FROM public.vehicles LIMIT 1';
         data=await connection.query(sql);
        vehicleId=data.rows[0].id;
        console.log(city,userId,vehicleId);

        // Calls without pool 
        let start = new Date();
        for (let ti = 0; ti < threads; ti++) {
            promises.push(directCalls(loops));
        }
        await Promise.all(promises).then((promise) => {
            if (debug) console.log(promise);
        });
        console.log('direct ', ((new Date()) - start));

        // Using the connection pool
        promises = [];
        start = new Date();
        for (let ti = 0; ti < threads; ti++) {
            promises.push(poolCalls(loops));
        }
        await Promise.all(promises).then((promise) => {
            if (debug) console.log(promise);
        });
        console.log('pool ', ((new Date()) - start));

        process.exit(0);
    } catch (error) {
        console.error(error.stack);
    }
    // process.exit(0);
}

async function directCalls(count) {
    let date;
    for (let i = 0; i < count; i++) {
         date = await newRide(city, userId, vehicleId, '1 Direct St Via Apt. 28');
    }
    return (date);
}

async function poolCalls(count) {
    let date;
    for (let i = 0; i < count; i++) {
         date = await newRidePool(city, userId, vehicleId, '2 Pool St Via Apt. 28');
    }
    return (date);
}


async function dbTime() {
    const connection = new pg.Client(connectionString);
    await connection.connect();
    const sql = 'SELECT NOW() AS TIME';
    const data = await connection.query(sql);
    await connection.end();
    return (data.rows[0]);
}

async function dbTimePool() {
    const connection = await pool.connect();
    const sql = 'SELECT NOW() AS TIME';
    const data = await connection.query(sql);
    await connection.release();
    return (data.rows[0]);
}

async function newRide(city, riderId, vehicleId, startAddress) {
    const connection = new pg.Client(connectionString);
    await connection.connect();
    const sql = `INSERT INTO movr.rides
    (id, city,rider_id,vehicle_id,start_address,start_time)
    VALUES(gen_random_uuid(), $1,$2,$3,$4,now())`;
    await connection.query(sql, [city, riderId, vehicleId, startAddress]);
    await connection.end();
}

async function newRidePool(city, riderId, vehicleId, startAddress) {
    const connection = await pool.connect();
    const sql = `INSERT INTO movr.rides
                 (id, city,rider_id,vehicle_id,start_address,start_time)
                 VALUES(gen_random_uuid(), $1,$2,$3,$4,now())`;
    await connection.query(sql, [city, riderId, vehicleId, startAddress]);
    await connection.release();
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
