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
    Simple example of CRUD operations in NodeJS */
    
const CrClient = require('pg').Client;

async function main() {
    try {
        if (process.argv.length != 3) {
            console.log(`Usage: node ${process.argv[1]} CONNECTION_URI`);
            process.exit(1);
        }

        const connection = new CrClient(process.argv[2]);
        await connection.connect();

        await connection.query('DROP TABLE IF EXISTS names');
        await connection.query('CREATE TABLE names (name String PRIMARY KEY NOT NULL)');
        await connection.query(`INSERT INTO names (name) 
                                VALUES('Ben'),('Jesse'),('Guy')`);

        const data = await connection.query('SELECT name from names');
        data.rows.forEach((row) => {
            console.log(row.name);
        });
    } catch (error) {
        console.error(error.stack);
    }
    process.exit(0);
}

main();
