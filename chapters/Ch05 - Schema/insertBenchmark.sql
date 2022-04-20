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

/* Insert tests */

\set errexit false;

DROP TABLE baseTable;

CREATE TABLE baseTable AS 
with recursive series as (
	select 1 as id union all
	select id + 1 as id
   from series
   where id < 20000)
  SELECT id,random() rnumber, md5(random()::STRING) rstring FROM series;
  


 
DROP TABLE seq_keyed;
DROP SEQUENCE seq_seq;
CREATE SEQUENCE seq_seq;

CREATE TABLE seq_keyed  (
	pk INT NOT NULL PRIMARY KEY   ,
	id int,
	rnumber float,
	rstring string
);

SELECT 'integer';

INSERT INTO seq_keyed (pk,id,rnumber,rstring) SELECT id,id,rnumber,rstring FROM basetable;


DROP TABLE seq_keyed;
DROP SEQUENCE seq_seq;
CREATE SEQUENCE seq_seq;

CREATE TABLE seq_keyed  (
	pk INT NOT NULL PRIMARY KEY DEFAULT nextval('seq_seq'),
	id int,
	rnumber float,
	rstring string
);

SELECT 'sequence';

INSERT INTO seq_keyed (id,rnumber,rstring) SELECT * FROM basetable;

DROP TABLE serial_keyed;

CREATE TABLE serial_keyed  (
	pk SERIAL PRIMARY KEY NOT NULL  ,
	id int,
	rnumber float,
	rstring string
);

SELECT 'serial';

INSERT INTO serial_keyed (id,rnumber,rstring) SELECT * FROM basetable;
;

DROP TABLE uuid_keyed;

CREATE TABLE uuid_keyed  (
	pk uuid NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(), 
	id int,
	rnumber float,
	rstring string
);

SELECT 'UUID';

INSERT INTO uuid_keyed (id,rnumber,rstring) SELECT * FROM basetable;

SET experimental_enable_hash_sharded_indexes=on;

DROP TABLE hash_keyed;

CREATE TABLE hash_keyed  (
	pk int NOT NULL,
	id int,
	rnumber float,
	rstring STRING,
	PRIMARY KEY (pk) USING HASH WITH BUCKET_COUNT=6
);

SELECT 'hash';

INSERT INTO hash_keyed (pk,id,rnumber,rstring) SELECT id,id,rnumber,rstring FROM basetable;




 

