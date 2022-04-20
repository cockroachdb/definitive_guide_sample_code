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

DROP TABLE arrayTable;

CREATE TABLE arrayTable (arrayColumn STRING[]);
CREATE TABLE c (d INT ARRAY);

INSERT INTO arrayTable VALUES (ARRAY['sky', 'road', 'car']);
SELECT arrayColumn[2] FROM arrayTable;
 
 
SELECT * FROM arrayTable WHERE arrayColumn @>ARRAY['road'];

UPDATE  arrayTable
   SET arrayColumn=array_append(arrayColumn,'cat')
  WHERE arrayColumn @>ARRAY['car']
 RETURNING arrayColumn ;
  
 
 
UPDATE  arrayTable
   SET arrayColumn=array_remove(arrayColumn,'car')
  WHERE arrayColumn @>ARRAY['car']
  RETURNING arrayColumn;
  
 
SELECT * FROM information_schema."tables" WHERE table_schema='information_schema';

SELECT table_catalog, table_schema, table_name, table_type  
FROM information_schema."tables";

SELECT column_name,data_type, is_nullable,column_default 
 FROM information_schema.COLUMNS WHERE TABLE_NAME='customers';
 