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

DROP TABLE people;

CREATE TABLE people ( id INT PRIMARY KEY, firstName VARCHAR NOT NULL, lastName VARCHAR NOT NULL, dateOfBirth timestamp NOT NULL, phoneNumber VARCHAR NOT NULL, 
fullName STRING AS (CONCAT(firstName, ' ', lastName) ) STORED, 
age int AS (now()-dateOfBirth) VIRTUAL );

CREATE TABLE people ( id INT PRIMARY KEY, firstName VARCHAR NOT NULL, lastName VARCHAR NOT NULL, dateOfBirth timestamp NOT NULL, phoneNumber VARCHAR  NULL, 
fullName STRING AS (CONCAT(firstName, ' ', lastName) ) STORED );

INSERT INTO people (id, firstName, lastName, dateOfBirth)
VALUES(1, 'Guy', 'Harrison', '21-JUN-1960');

SELECT * FROM people;

UPDATE people SET firstname='Fred';

SELECT * FROM people;
USE movr;
SELECT CAST(revenue AS int) FROM rides;

CREATE INDEX people_namedob_ix ON
people (lastName, firstName, dateOfBirth);

DROP INDEX people_namedob_ix;

CREATE UNIQUE INDEX people_namedob_ix ON
people (lastName, firstName, dateOfBirth);

DROP INDEX people_namedob_ix;

CREATE UNIQUE INDEX people_namedob_ix ON
people (lastName, firstName, dateOfBirth) STORING (phoneNumber);

INSERT INTO people (id, firstName, lastName, dateOfBirth)
VALUES(1, 'Guy', 'Harrison', '21-JUN-1960');

SELECT *
FROM people;

SELECT NOW()-dateOfBirth
FROM people;

DROP TABLE people;

CREATE TABLE people ( id UUID NOT NULL DEFAULT gen_random_uuid(), firstName VARCHAR NOT NULL, lastName VARCHAR NOT NULL, dateOfBirth DATE NOT NULL );

INSERT INTO people (firstName, lastName, dateOfBirth)
VALUES('Guy', 'Harrison', '21-JUN-1960');

CREATE TABLE peopleStagingData AS 
SELECT * FROM people;

INSERT INTO people (firstName, lastName, dateOfBirth)
SELECT firstName, lastName, dateOfBirth
  FROM peopleStagingData;
 
DELETE FROM people 
 WHERE firstName='Guy'
   AND lastName='Harrison';
  


SELECT *
FROM people;

DROP TABLE people;

CREATE TABLE people 
 ( id UUID NOT NULL DEFAULT gen_random_uuid(), 
   personData JSONB );

INSERT INTO people (personData)
VALUES('{
		"firstName":"Guy",
        "lastName":"Harrison",
        "dob":"21-Jun-1960",
        "phone":"0419533988",
        "photo":"eyJhbGciOiJIUzI1NiIsI..."
     }');

SELECT personData->'phone'
FROM people
WHERE personData->>'phone' = '"0419533988"';

CREATE INVERTED INDEX people_inv_idx ON
people(personData);

SELECT *
FROM people
WHERE personData @> '{"phone":"0419533988"}';

EXPLAIN SELECT *
FROM people
WHERE personData @> '{"phone":"0419533988"}';

ALTER TABLE people ADD phone STRING AS (personData->>'phone') VIRTUAL;

CREATE INDEX people_phone_idx ON people(phone);


EXPLAIN SELECT id
FROM people
WHERE phone = '0419533988';

DROP TABLE people;

CREATE TABLE people 
( id INT PRIMARY KEY, 
  firstName VARCHAR NOT NULL, 
  lastName VARCHAR NOT NULL, 
  dateOfBirth timestamp NOT NULL, 
  phoneNumber VARCHAR NOT NULL,
  serialNo SERIAL ,
  INDEX serialNo_idx (serialNo) USING HASH WITH BUCKET_COUNT=4);
  
/* ORDERING */
 
 USE movr 
 
 EXPLAIN SELECT id, city, "name", address, credit_card
FROM movr.public."users" ORDER BY INDEX users@city_idx

CREATE INDEX city_idx ON "users" (city);

CREATE TABLE user_ride_counts AS
SELECT u.name, COUNT(u.name) AS rides 
  FROM "users" AS u JOIN "rides" AS r 
    ON (u.id=r.rider_id)
 GROUP BY u.name
 
 /* Imprt */
 
 IMPORT TABLE customers (
        id UUID PRIMARY KEY,
        name TEXT,
        INDEX name_idx (name)
)
CSV DATA ('s3://acme-co/customers.csv?AWS_ACCESS_KEY_ID=[placeholder]&AWS_SECRET_ACCESS_KEY=[placeholder]&AWS_SESSION_TOKEN=[placeholder]')
;

IMPORT TABLE customers (
        id INT PRIMARY KEY,
        name STRING,
        INDEX name_idx (name)
)
CSV DATA ('nodelocal://1/customers.csv');

 USE movr 
  
SELECT COUNT(*) FROM rides 
 WHERE (end_time-start_time)= 
 	(SELECT MAX(end_time-start_time) FROM rides );
 
 
SELECT id, city,(end_time-start_time) ride_duration, avg_ride_duration
FROM rides
JOIN (SELECT city, AVG(end_time-start_time) avg_ride_duration
		FROM rides
		GROUP BY city)
	USING(city) ;
    
