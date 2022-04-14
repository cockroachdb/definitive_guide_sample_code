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

/* Benchmarking various transactional idioms */

const pg = require('pg');


if (process.argv.length != 7) {
    console.log(`Usage: node ${process.argv[1]} CONNECTION_URI threads loops sleepMs nLocations`);
    process.exit(1);
}

const connectionString = process.argv[2];
const threads = parseInt(process.argv[3]);
const loops = parseInt(process.argv[4]);
const sleepTime = parseInt(process.argv[5]);
const nLocations = parseInt(process.argv[6]);

const pool = new pg.Pool({
    connectionString,
    max: 100
});
// const connection = await pool.connect();
const connection = new pg.Client(connectionString);


const locationIds = [];
const elapsedTimes = {
    noRetry: [],
    retrySavepoint: [],
    retry: [],
    forUpdate: []
};

async function main() {
    const debug = false;
    try {
        await connection.connect();
        // Check parameters

        await setup(nLocations);


        const locations = await connection.query('SELECT id FROM locations');

        locations.rows.forEach((loc) => {
            locationIds.push(loc.id);
        });

        // Calls without retry
       await multiThreads(threads, loops, serializationError);

        await multiThreads(threads, loops, takeMeasurementBatched);
        await multiThreads(threads, loops, takeMeasurement); 

        await multiThreads(threads, loops, takeMeasurementWithRetry);
        await multiThreads(threads, loops, takeMeasurementWithRetryLocation1st);


        await multiThreads(threads, loops, takeMeasurementForUpdateInside);
        await multiThreads(threads, loops, takeMeasurementForUpdateOutside); 

        await multiThreads(threads, loops, takeMeasurementInsideTxn);
        await multiThreads(threads, loops, takeMeasurementOutsideTxn);

        await multiThreads(threads, loops, takeMeasurement);
        await multiThreads(threads, loops, takeMeasurementForUpdate);

        await multiThreads(threads, loops, takeMeasurementWithRetrySavepoint);  


        Object.keys(elapsedTimes).forEach((type) => {
            console.log(type, ' avg ', avg(elapsedTimes[type]));
        });

        if (debug) traceStats(connection);
        process.exit(0);
    } catch (error) {
        console.error(error.stack);
    }
    // process.exit(0);
}

async function multiThreads(threads, loops, functionName) {
    console.log('-----', functionName.name, '---------');
    const start = new Date();
    const promises = [];
    for (let ti = 0; ti < threads; ti++) {
        promises.push(multipleMeasurements(loops, functionName));
    }
    let successCount = 0;
    await Promise.all(promises).then((promise) => {
        promise.forEach((p) => {
            successCount += p;
        });
    });
    console.log('return value ', successCount, ' ', (successCount * 100) / (loops * threads), '%');
    console.log('elapsed ', ((new Date()) - start));
    return {
        successCount,
        promises
    };
}

async function takeMeasurementInsideTxn(locationId, measurement) {
    let success = false;
    const measurementTime = new Date();
    const connection = await pool.connect();
    try {
        await connection.query('BEGIN TRANSACTION');
        await getMeasurementFromDevice();
        await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);
        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        // console.error(error.message);
        connection.query('ROLLBACK');
        success = false;
    }
    connection.release();
    return (success);
}

async function takeMeasurementOutsideTxn(locationId, measurement) {
    let success = false;
    const measurementTime = new Date();
    const connection = await pool.connect();
    try {
        await getMeasurementFromDevice();
        await connection.query('BEGIN TRANSACTION');

        await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);
        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        // console.error(error.message);
        connection.query('ROLLBACK');
        success = false;
    }
    connection.release();
    return (success);
}

async function getMeasurementFromDevice() {
    await sleep(100 + Math.round(Math.random() * 100));
}


async function takeMeasurement(locationId, measurement) {
    let success = false;
    const measurementTime = new Date();
    const connection = await pool.connect();
    try {
        await connection.query('BEGIN TRANSACTION');

        await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);
        await connection.query('COMMIT');
        process.stdout.write('.');
        success = true;
    } catch (error) {
        process.stdout.write('e');
        connection.query('ROLLBACK');
        success = false;
    }
    connection.release();
    return (success);
}

async function takeMeasurementBatched(locationId, measurement) {
    let success = false;
    const connection = await pool.connect();
    try {
        const txnSql = `
        BEGIN ;
        INSERT INTO measurements
             (locationId,measurement) 
               VALUES('${locationId}',${measurement});
        UPDATE locations 
           SET last_measurement=${measurement}, last_timestamp=now()
         WHERE id='${locationId}';
        COMMIT;
        `;
        await connection.query(txnSql);

        success = true;
    } catch (error) {
        process.stdout.write(error.message);
        success = false;
    }
    connection.release();
    return (success);
}

async function takeMeasurementForUpdate(locationId, measurement) {
    let success = false;
    const connection = await pool.connect();
    const measurementTime = new Date();
    try {
        await connection.query('BEGIN TRANSACTION');
        await connection.query(`SELECT id FROM locations 
                                 WHERE id=$1
                                   FOR UPDATE`, [locationId]);
        const insertReturn = await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2) RETURNING (measurement_timestamp)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);

        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        console.error(error.message);
        connection.query('ROLLBACK');
    }
    connection.release();
    return (success);
}

async function serializationError(locationId, measurement) {
    let success = false;
    const connection = await pool.connect();
    const measurementTime = new Date();
    try {
        await connection.query('BEGIN TRANSACTION');

        const insertReturn = await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2) RETURNING (measurement_timestamp)`,
            [locationId, measurement]
        );
        await connection.query('COMMIT');
        await connection.query('BEGIN TRANSACTION');
        const current = await connection.query(
            `SELECT measurement FROM measurements
                         WHERE locationId=$1 ORDER BY measurement_timestamp DESC LIMIT 1`, [locationId]);

        console.log('Previous measurement', current.rows[0].measurement);
        await connection.query(
            `UPDATE locations 
                           SET last_measurement=$1, last_timestamp=$2
                         WHERE id=$3`,
            [measurement, measurementTime, locationId]);

        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        console.error('error', error.message);
        try {
            connection.query('ROLLBACK');
        } catch (e) {}
    }
    connection.release();
    return (success);
}

async function takeMeasurementForUpdateInside(locationId, measurement) {
    let success = false;
    const connection = await pool.connect();
    const measurementTime = new Date();
    try {
        await connection.query('BEGIN TRANSACTION');
        await connection.query(`SELECT id FROM locations 
                                 WHERE id=$1
                                   FOR UPDATE`, [locationId]);
        await getMeasurementFromDevice();
        const insertReturn = await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2) RETURNING (measurement_timestamp)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);

        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        console.error(error.message);
        connection.query('ROLLBACK');
    }
    connection.release();
    return (success);
}

async function takeMeasurementForUpdateOutside(locationId, measurement) {
    let success = false;
    const connection = await pool.connect();
    const measurementTime = new Date();
    try {
        await getMeasurementFromDevice();
        await connection.query('BEGIN TRANSACTION');
        await connection.query(`SELECT id FROM locations 
                                 WHERE id=$1
                                   FOR UPDATE`, [locationId]);
        const insertReturn = await connection.query(
            `INSERT INTO measurements
                                (locationId,measurement) 
                                VALUES($1,$2) RETURNING (measurement_timestamp)`,
            [locationId, measurement]
        );
        await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
            [measurement, measurementTime, locationId]);

        await connection.query('COMMIT');
        success = true;
    } catch (error) {
        console.error(error.message);
        connection.query('ROLLBACK');
    }
    connection.release();
    return (success);
}

function avg(array) {
    let sum = 0;
    for (let i = 0; i < array.length; i++) {
        sum += array[i];
    }
    return (sum / array.length);
}

async function takeMeasurementWithRetry(locationId, measurement, maxRetries = 100) {
    const connection = await pool.connect();
    const measurementTime = new Date();
    let retryCount = 0;
    let transactionEnd = false;
    while (!transactionEnd) {
        retryCount += 1;
        if (retryCount >= maxRetries) {
            throw Error('Maximum retry count exceeded');
        } else {
            try {
                await connection.query('BEGIN TRANSACTION');
                await connection.query(
                    `INSERT INTO measurements
                                        (locationId,measurement) 
                                        VALUES($1,$2)`,
                    [locationId, measurement]
                );
                await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
                    [measurement, measurementTime, locationId]);
                await connection.query('COMMIT');
                transactionEnd = true;
            } catch (error) {
                if (error.code == '40001') { // Rollback and retry
                    connection.query('ROLLBACK');
                    const sleepTime = (2 ** retryCount) * 100 + Math.ceil(Math.random() * 100);
                    // console.warn('Sleeping for ', sleepTime);
                    await sleep(sleepTime);
                } else {
                    console.log('aborted ', error.message);
                    transactionEnd = true;
                }
            }
        }
    }
    connection.release();
    return (retryCount);
}

async function takeMeasurementWithRetryLocation1st(locationId, measurement, maxRetries = 100) {
    const connection = await pool.connect();
    const measurementTime = new Date();
    let retryCount = 0;
    let transactionEnd = false;
    while (!transactionEnd) {
        retryCount += 1;
        if (retryCount >= maxRetries) {
            throw Error('Maximum retry count exceeded');
        } else {
            try {
                await connection.query('BEGIN TRANSACTION');
                await connection.query(`UPDATE locations 
                                           SET last_measurement=$1, last_timestamp=$2
                                         WHERE id=$3`,
                    [measurement, measurementTime, locationId]);
                await connection.query(
                    `INSERT INTO measurements
                                        (locationId,measurement) 
                                        VALUES($1,$2)`,
                    [locationId, measurement]
                );
                await connection.query('COMMIT');
                transactionEnd = true;
            } catch (error) {
                if (error.code == '40001') { // Rollback and retry
                    connection.query('ROLLBACK');
                    const sleepTime = (2 ** retryCount) * 100 + Math.ceil(Math.random() * 100);
                    // console.warn('Sleeping for ', sleepTime);
                    await sleep(sleepTime);
                } else {
                    console.log('aborted ', error.message);
                    transactionEnd = true;
                }
            }
        }
    }
    connection.release();
    return (retryCount);
}

async function takeMeasurementWithRetrySavepoint(locationId, measurement, maxRetries = 100) {
    const connection = await pool.connect();
    const measurementTime = new Date();
    let retryCount = 0;
    let transactionEnd = false;
    await connection.query('BEGIN TRANSACTION');
    while (!transactionEnd) {
        retryCount += 1;
        if (retryCount >= maxRetries) {
            throw Error('Maximum retry count exceeded');
        } else {
            try {
                await connection.query('SAVEPOINT cockroach_restart');
                await connection.query(
                    `INSERT INTO measurements
                                        (locationId,measurement) 
                                        VALUES($1,$2)`,
                    [locationId, measurement]
                );
                await connection.query(`UPDATE locations 
                                   SET last_measurement=$1, last_timestamp=$2
                                 WHERE id=$3`,
                    [measurement, measurementTime, locationId]);
                await connection.query('RELEASE SAVEPOINT cockroach_restart');
                await connection.query('COMMIT');
                transactionEnd = true;
            } catch (error) {
                if (error.code == '40001') { // Rollback and retry
                    connection.query('ROLLBACK TO SAVEPOINT cockroach_restart');
                } else {
                    console.log('aborted ', error.message);
                    connection.query('ROLLBACK');
                    transactionEnd = true;
                }
            }
        }
    }
    connection.release();
    return (retryCount);
}

async function multipleMeasurements(count, functionName) {
    elapsedTimes[functionName.name] = [];
    let successCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await functionName(randomId, randomValue);
        elapsedTimes[functionName.name].push((new Date()) - start);
        await sleep(sleepTime);
        if (s) successCount += s;
    }
    return (successCount);
}


async function setup(locationCount) {
    try {
        const sqls = [];
        sqls.push('DROP TABLE IF EXISTS measurements');
        sqls.push('DROP TABLE IF EXISTS locations');

        sqls.push(`CREATE TABLE locations (id uuid primary KEY DEFAULT gen_random_uuid(),
                                            description STRING NOT NULL,
                                            last_measurement float,
                                            last_timestamp timestamp)`);

        sqls.push(`CREATE TABLE measurements (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                               locationId uuid NOT NULL ,
                               measurement_timestamp timestamp DEFAULT now(),
                               measurement float,
                               CONSTRAINT measurement_fk1 FOREIGN KEY (locationId) REFERENCES locations(id))`);

        sqls.push(`INSERT INTO locations (description )
            WITH RECURSIVE series AS 
                ( SELECT 0 AS id
                    UNION ALL 
                SELECT id +1 AS id
                    FROM series
                    WHERE id < ${locationCount} ) 
            SELECT  md5(random()::STRING) randomString  FROM series `);
        for (let si = 0; si < sqls.length; si++) {
            console.log(sqls[si]);
            await connection.query(sqls[si]);
        }
    } catch (error) {
        console.log(error.message);
    }
}

async function multiMeasurementsForUpdate(count) {
    let successCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await takeMeasurementForUpdate(randomId, randomValue);
        elapsedTimes.forUpdate.push((new Date()) - start);
        await sleep(sleepTime);
        if (s) successCount += 1;
    }
    return (successCount);
}

async function multiMeasurementsRetry(count) {
    let retryCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await takeMeasurementWithRetry(randomId, randomValue, 100000);
        elapsedTimes.retry.push((new Date()) - start);
        await sleep(sleepTime);
        retryCount += s;
    }
    return (retryCount);
}

async function multiMeasurementsRetrySavepoint(count) {
    let retryCount = 0;
    for (let i = 0; i < count; i++) {
        const randomId = locationIds[Math.floor(Math.random() * locationIds.length)];
        const randomValue = Math.random() * 100;
        const start = new Date();
        const s = await takeMeasurementWithRetrySavepoint(randomId, randomValue, 100000);
        elapsedTimes.retrySavepoint.push((new Date()) - start);
        await sleep(sleepTime);
        retryCount += s;
    }
    return (retryCount);
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

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

main();