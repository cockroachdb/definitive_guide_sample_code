
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
USE movr;
\set display_format=table 

SHOW STATISTICS FOR table rides;

WITH rides_statistics AS (
  SELECT *
    FROM [SHOW STATISTICS FOR TABLE rides])
SELECT column_names,row_count,distinct_count,null_count
  FROM rides_statistics r
 WHERE created =(
	SELECT max(created)
     FROM rides_statistics
    WHERE column_names=r.column_names
);

 
SELECT * FROM [SHOW JOBS] 
 WHERE job_type LIKE '%CREATE STATS%' 
 ORDER BY finished DESC LIMIT 1;

SELECT distinct job_type FROM [SHOW jobs]

CREATE STATISTICS city_routes ON start_address, end_address FROM movr.public.rides
;

CREATE STATISTICS ON * FROM rides;

\SET display_format=records;

SELECT * FROM [SHOW CLUSTER SETTINGS]  WHERE variable LIKE '%sql%';

SELECT variable, description FROM [SHOW CLUSTER SETTINGS] WHERE description LIKE '%join%';