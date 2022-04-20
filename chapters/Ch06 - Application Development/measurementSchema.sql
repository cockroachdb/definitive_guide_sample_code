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

measurements schema used in some examples

*/

USE chapter06;

CREATE SCHEMA measurements;

SET SCHEMA measurements;

DROP TABLE IF EXISTS measurements;
DROP TABLE IF EXISTS locations;

CREATE TABLE locations (id uuid primary KEY DEFAULT gen_random_uuid(),
                        description STRING NOT NULL,
                        last_measurement float,
                        last_timestamp timestamp);
                        
CREATE TABLE measurements (id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                           locationId uuid NOT NULL ,
                           measurement_timestamp timestamp DEFAULT now(),
                           measurement float,
                           CONSTRAINT measurement_fk1 FOREIGN KEY (locationId) REFERENCES locations(id));
                          
INSERT INTO locations (description )
 WITH RECURSIVE series AS 
     ( SELECT 100 AS id
        UNION ALL 
       SELECT id -1 AS id
         FROM series
        WHERE id > 0 ) 
SELECT  md5(random()::STRING) randomString  FROM series;
 
SELECT * FROM measurements;

SEEL