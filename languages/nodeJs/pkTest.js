const CrClient = require('pg').Client;

const debug = false;


async function main() {
    try {
        if (process.argv.length != 6) {
            console.log('Usage: node pkTest.js nConnections nRows sleepTime CONNECTION_URI');
            process.exit(1);
        }

        const nConnections = process.argv[2];
        const nRows = parseInt(process.argv[3]);
        const sleepTime = process.argv[4];
        const connectionString = process.argv[5];
        const connections = [];
        let data;

        const dbName = 'pktest' + Math.round((Math.random() * 10000));
        for (let ci = 0; ci < nConnections; ci++) {
            connections[ci] = new CrClient(connectionString);
            await connections[ci].connect();
            const data = await connections[ci].query(
                `SELECT CONCAT('Hello from CockroachDB at ',
                                CAST (NOW() as STRING)) as hello`
            );
            if (ci === 0) {
                await connections[ci].query(`CREATE DATABASE ${dbName}`);
            }
            console.log(data.rows[0].hello);


            await connections[ci].query(`use ${dbName}`);
        }
        await createTables(connections[0]);
        data = dataBatch(nRows, 0);


        // await insertTest(connections, 'int_keyed', true, data,sleepTime);
        await insertTest(connections, 'seq_keyed', false, data, sleepTime);
        // await insertTest(connections, 'seq_cached', false, data,sleepTime);
        await insertTest(connections, 'uuid_keyed', false, data, sleepTime);
        await insertTest(connections, 'serial_keyed', false, data, sleepTime);
        await insertTest(connections, 'hash_keyed', true, data, sleepTime);
        const nextStartId = nRows + 1;
        data = dataBatch(nRows, nextStartId);

        // await insertTest(connections, 'int_keyed', true, data,sleepTime);
        await insertTest(connections, 'seq_keyed', false, data, sleepTime);
        // await insertTest(connections, 'seq_cached', false, data,sleepTime);
        await insertTest(connections, 'uuid_keyed', false, data, sleepTime);
        await insertTest(connections, 'serial_keyed', false, data, sleepTime);
        await insertTest(connections, 'hash_keyed', true, data, sleepTime);
    } catch (error) {
        console.log(error.stack);
    }
    // Exit
    process.exit(0);
}

function dataBatch(rows, startId) {
    // console.log(rows,' ',startId);
    const data = [];
    //  Make this string large so we get lots of ranges
    let rstring = Math.random().toString(36).replace(/[^a-z]+/g, '');
    for (let rr = 0; rr < 14; rr++) {
        rstring += rstring;
    }

    const endKey = parseInt(startId) + parseInt(rows);
    // console.log('endkey',endKey);

    for (let ri = parseInt(startId); ri < endKey; ri += 1) {
        data.push({
            pk: ri,
            id: ri,
            rnumber: Math.random(),
            rstring
        });
    }
    return (data);
}

async function insertTest(connections, tableName, insertPk, data, sleepTime) {
    console.log('inserting into ', tableName);
    const start = new Date();
    let sqlText = `INSERT INTO ${tableName} (id,rnumber,rstring) VALUES($1,$2,$3)`;
    if (insertPk) {
        sqlText = `INSERT INTO ${tableName} (pk,id,rnumber,rstring) VALUES($1,$2,$3, $4)`;
    }

    const promises = [];

    for (let ci = 0; ci < connections.length; ci += 1) {
        promises.push(
            runQueries(connections[ci], connections.length, ci, data, sqlText, insertPk)
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

    console.log('sleeping for ', sleepTime);
    await sleep(sleepTime);
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
    const stmts = [];
    stmts.push('DROP TABLE IF EXISTS  seq_keyed');
    stmts.push('DROP TABLE IF EXISTS  seq_cached');
    stmts.push('DROP TABLE IF EXISTS  serial_keyed');
    stmts.push('DROP TABLE IF EXISTS  uuid_keyed');
    stmts.push('DROP TABLE IF EXISTS  hash_keyed');
    stmts.push('DROP TABLE IF EXISTS  int_keyed');
    stmts.push('DROP SEQUENCE  IF EXISTS  seq_seq');
    stmts.push('CREATE SEQUENCE   seq_seq');
    stmts.push('DROP SEQUENCE  IF EXISTS  seq_cache1000');
    stmts.push('CREATE SEQUENCE seq_cache1000 CACHE 1000');
    stmts.push(`
    CREATE TABLE seq_keyed  (
        pk INT NOT NULL PRIMARY KEY DEFAULT nextval('seq_seq')  ,
        id int,
        rnumber float,
        rstring string
    )`);
    stmts.push(`
    CREATE TABLE seq_cached  (
        pk INT NOT NULL PRIMARY KEY DEFAULT nextval('seq_cache1000')  ,
        id int,
        rnumber float,
        rstring string
    )`);
    stmts.push(`
    CREATE TABLE serial_keyed  (
        pk SERIAL PRIMARY KEY NOT NULL  ,
        id int,
        rnumber float,
        rstring string
    )`);
    stmts.push(`
    CREATE TABLE uuid_keyed  (
        pk uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(), 
        id int,
        rnumber float,
        rstring string
    )`);
    stmts.push(`
    CREATE TABLE int_keyed  (
        pk int not null primary key,
        id int,
        rnumber float,
        rstring string
    )`);
    stmts.push('SET experimental_enable_hash_sharded_indexes=on');
    stmts.push(`
    CREATE TABLE hash_keyed  (
        pk int NOT NULL,
        id int,
        rnumber float,
        rstring STRING,
        PRIMARY KEY (pk) USING HASH WITH BUCKET_COUNT=18
    )`);
    /* stmts.push(`
    INSERT INTO int_keyed (pk,id,rnumber,rstring)
    WITH RECURSIVE series AS (
    SELECT 1 AS id
     UNION ALL SELECT id + 1 AS id
      FROM series
     WHERE id < 500000 ), randoms AS ( SELECT id int_id,(random()* 10000000)::int randomInt, random() randomFloat, md5(random()::STRING) randomString ,
            ((now()-INTERVAL '30 years')+ (ROUND(random()* 20,2) || ' years')::INTERVAL)::date randomDate
      FROM series)
    SELECT int_id, int_id,randomInt::float,randomString||randomString||randomString||randomString  FROM randoms`);
    stmts.push('INSERT into uuid_keyed(id,rnumber,rstring) SELECT id,rnumber,rstring FROM int_keyed');
    stmts.push('INSERT into serial_keyed(id,rnumber,rstring) SELECT id,rnumber,rstring FROM int_keyed');
    stmts.push('INSERT into hash_keyed(pk,id,rnumber,rstring) SELECT pk,id,rnumber,rstring FROM int_keyed');
    stmts.push('INSERT into seq_keyed(pk,id,rnumber,rstring) SELECT pk,id,rnumber,rstring FROM int_keyed'); */
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

function sleep(ms) {
    return new Promise((resolve) => {
        setTimeout(resolve, ms);
    });
}

main();
