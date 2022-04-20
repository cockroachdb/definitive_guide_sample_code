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

/* Bencharking indexes vs scans */

@set nrows = 1000000
SELECT ${nrows};
 


DROP TABLE clustered_data;
DROP table unclustered_data;

CREATE TABLE clustered_data (pk int NOT NULL PRIMARY KEY, indColumn int NOT NULL, textData STRING, dateData date);

CREATE TABLE unclustered_data (pk uuid NOT NULL PRIMARY KEY, indColumn int NOT NULL, textData STRING, dateData date);




INSERT INTO clustered_data (pk,indColumn,textData,dateData)
WITH RECURSIVE series AS ( SELECT 1 AS id
UNION ALL SELECT id + 1 AS id
FROM series
WHERE id < ${nrows} ), randoms AS ( SELECT id int_id,(random()* 10000000)::int randomInt, random() randomFloat, md5(random()::STRING) randomString ,
      ((now()-INTERVAL '30 years')+ (ROUND(random()* 20,2) || ' years')::INTERVAL)::date randomDate
FROM series) 
SELECT int_id, int_id,randomString, randomDate
FROM randoms;

INSERT INTO unclustered_data (pk,indColumn,textData,dateData)
SELECT gen_random_uuid(),indColumn, textData,dateData
  FROM clustered_data;
  
CREATE INDEX clustered_data_i1 ON clustered_data(indColumn);
CREATE INDEX unclustered_data_i1 ON unclustered_data(indColumn);

SELECT 'clustered primary';

@set tt = clustered_data@clustered_data_i1 

SELECT "@tt";

EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/1000;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/500 ;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/100 ;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/80;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/50;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/25;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/10;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/5;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/4;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/3;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/2;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/1.5;
EXPLAIN ANALYZE SELECT MAX(dateData)FROM ${tt} WHERE indcolumn< ${nrows}/1;
 
@set tt = clustered_data@primary

SELECT "@tt";

EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/1000;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/500 ;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/100 ;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/80;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/50;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt}  WHERE indcolumn< ${nrows}/25;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/10;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/5;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/4;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/3;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/2;
EXPLAIN ANALYZE SELECT MAX(dateData) FROM ${tt} WHERE indcolumn< ${nrows}/1.5;
EXPLAIN ANALYZE SELECT MAX(dateData)FROM ${tt} WHERE indcolumn< ${nrows}/1;
  SELECT ROUND(random(),2)
