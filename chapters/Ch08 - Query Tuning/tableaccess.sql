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
\set prompt1=%/>

USE movr;

DROP INDEX rides_address_times_ix;
DROP INDEX rides_address_ix;

EXPLAIN
SELECT start_time, end_time
FROM rides
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet'
AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN ANALYSE 
SELECT start_time, end_time
FROM rides
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet'
AND end_address = '57998 Harvey Burg Suite 87';

CREATE INDEX rides_address_ix ON rides(city,start_address,end_address);

EXPLAIN 
SELECT start_time, end_time
FROM rides
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet'
AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN ANALYZE
SELECT start_time, end_time
FROM rides
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet'
AND end_address = '57998 Harvey Burg Suite 87';


CREATE INDEX rides_address_times_ix ON rides(city,start_address,end_address) STORING (start_time,end_time);

EXPLAIN 
SELECT start_time, end_time
FROM rides@rides_address_times_ix
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet'
AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN ANALYZE
SELECT start_time, end_time
FROM rides
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet'
AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN 
SELECT start_time, end_time
FROM rides
WHERE city = 'amsterdam'
AND start_address = '67104 Farrell Inlet';

EXPLAIN (OPT) 
SELECT start_time, end_time
FROM rides@primary
WHERE city = 'amsterdam'
AND end_address = '57998 Harvey Burg Suite 87';

EXPLAIN 
SELECT start_time, end_time
FROM rides  
WHERE end_address = '57998 Harvey Burg Suite 87';

DROP INDEX rides_address_times_ix;
DROP INDEX rides_address_ix;

CREATE INDEX user_address_ix ON USERS(address) STORING (name);

EXPLAIN SELECT name FROM USERS WHERE address='20069 Tara Cove';

EXPLAIN SELECT name FROM USERS WHERE address LIKE '% Tara Cove';

EXPLAIN SELECT name FROM USERS WHERE upper(address)=UPPER('20069 Tara Cove');

EXPLAIN SELECT name FROM USERS WHERE address ILIKE '20069 Tara Cove';



