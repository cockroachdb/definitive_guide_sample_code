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

/* JSON examples */

CREATE TABLE cities (
	cityid UUID PRIMARY KEY NOT NULL default gen_random_uuid(),
	name varchar NOT null
	);

INSERT INTO cities (name) values('Melbourne');

SELECT * FROM cities; 

//ALTER TABLE people ADD phone STRING AS (personData->>'phone') VIRTUAL;

DROP TABLE people;

CREATE TABLE people (
	personId UUID PRIMARY KEY NOT NULL default gen_random_uuid(),
	cityId UUID ,
  	personData JSONB,
  	FirstName STRING AS (personData->>'FirstName') VIRTUAL,
  	LastName STRING AS (personData->>'LastName') VIRTUAL,
  	FOREIGN KEY (cityId) REFERENCES cities(cityid),
  	INDEX  (LastName,Firstname)
);

INSERT INTO people (personData) VALUES(
'{ "Address" : "1913 Hanoi Way",
	"City" : "Sasebo",
	"Country" : "Japan",
	"District" : "Nagasaki",
	"FirstName" : "Mary",
	"LastName" : "Smith",
	"Phone" : "886780309",
	"dob" :  "1982-02-20T13:00:00Z",
    "likes": ["Dinosaurs","Dogs","People"] }');
     
SELECT * FROM people; 

EXPLAIN SELECT * FROM people WHERE LastName='Smith' AND FirstName='Mary';

