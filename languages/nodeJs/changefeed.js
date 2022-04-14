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
    Example of consuming a change feed in NodeJS
    */
   
const pg = require('pg');

if (process.argv.length != 3) {
    console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
    process.exit(1);
}
const connectionString = process.argv[2];
const connection = new pg.Client(connectionString);

async function main() {
    try {
        await connection.connect();
        const sql = 'EXPERIMENTAL CHANGEFEED FOR movr.rides WITH updated, resolved';
        const query = new pg.Query(sql);

        query.on('row', (row) => {
            console.log(row.value.toString());
        });
        query.on('error', (error) => console.eror(error));
        query.on('end', () => {
            console.log('Change feed terminated');
            process.exit(0);
        });
        await connection.query(query);
    } catch (error) {
        console.error(error.stack);
    }
}

main();
