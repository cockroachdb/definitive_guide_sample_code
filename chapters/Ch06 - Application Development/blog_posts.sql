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

Blog post schema used in some examples 

*/

CREATE DATABASE chapter06;

USE chapter06;

DROP TABLE IF EXISTS  blog_posts ;

CREATE TABLE blog_posts
(id uuid NOT NULL PRIMARY KEY default gen_random_uuid(),
 post_timestamp timestamp NOT NULL ,
 userid int,
 summary string);
 

INSERT INTO blog_posts ( post_timestamp,userid,summary)
 WITH RECURSIVE series AS 
     ( SELECT 525600*10 AS id
        UNION ALL 
       SELECT id -1 AS id
         FROM series
        WHERE id > 0 ) 
SELECT ((date '20220101') -   (id||' minutes')::INTERVAL)::timestamp , ROUND(random()*1000)::int , 
md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING)||md5(random()::STRING) randomString  FROM series;

DROP INDEX IF EXISTS timeseries_covering;
CREATE INDEX timeseries_covering ON blog_posts(post_timestamp DESC) STORING (summary);

analyze  blog_posts;

EXPLAIN ANALYZE SELECT post_timestamp, summary FROM blog_posts ORDER BY post_timestamp DESC 