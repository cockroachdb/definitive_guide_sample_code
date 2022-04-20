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

DROP TABLE orderdetails;
 

CREATE TABLE orderdetails AS SELECT * FROM adventureworks.sales.salesorderdetail s;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate  LIMIT 10;;

CREATE INDEX orderdetails_moddate_ix ON orderdetails(modifieddate) ;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails@orderdetails_moddate_ix ORDER BY modifieddate;

EXPLAIN ANALYZE SELECT * FROM orderdetails ORDER BY modifieddate LIMIT 10;

SELECT * 
  FROM orderdetails 
 ORDER BY modifieddate;
 
SET experimental_enable_hash_sharded_indexes=on;

CREATE INDEX orderdetails_hash_ix 
    ON orderdetails(modifieddate) 
 USING HASH WITH BUCKET_COUNT=6;

DROP INDEX orderdetails_moddate_ix;

EXPLAIN ANALYZE SELECT * FROM orderdetails@orderdetails_hash_ix  ORDER BY modifieddate LIMIT 10;
