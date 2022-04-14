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

const CrClient = require('pg').Client; //load pg client

async function main() {
    try {
        // Check parameters
        if (process.argv.length != 3) {
            console.log('Usage: node helloWorld.js CONNECTION_URI');
            process.exit(1);
        }
        // Establish a connection using the command line URI
        const connectionString = process.argv[2];
        const crClient = new CrClient(connectionString);
        await crClient.connect();

        // Issue a SELECT 
        const data = await crClient.query(
            `SELECT CONCAT('Hello from CockroachDB at ',
                            CAST (NOW() as STRING)) as hello`
        );
        // Print out the error message
        console.log(data.rows[0].hello);
    } catch (error) {
        console.log(error.stack);
    }
    // Exit
    process.exit(0);
}

main();