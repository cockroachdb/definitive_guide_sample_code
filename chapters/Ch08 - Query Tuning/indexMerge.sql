CREATE DATABASE chapter08;

USE chapter08;


DROP TABLE iotData;

CREATE TABLE iotData AS 
WITH RECURSIVE series AS (
	SELECT 1 AS id
UNION ALL
	SELECT id + 1 AS id
FROM series
WHERE id < 2000000),
   numbers AS (
     SELECT id, round(random()* 1000)::integer rnumber, md5(random()::STRING) rstring
FROM series
   )
  SELECT rnumber, round(rnumber / 100)::integer country_code ,
  round(rnumber / 10)::integer state_code ,
  rnumber city_code ,
  (random()*100)::integer obs_type,
  random() measurement,
  CAST(concat(floor(2000 + random()* 20)::STRING, '-', floor(1 + random()* 12)::STRING, '-', floor(1 + random()* 28)::STRING) AS date) obsDate
FROM numbers
ORDER BY 1, 2;

CREATE INDEX iotCountry_ix ON iotData(country_code);
CREATE INDEX iotState_ix ON iotData(state_code);
CREATE INDEX iotCity_ix ON iotData(city_code);
CREATE INDEX iotDate_ix ON iotData(obsDate);
CREATE INDEX iotType_ix ON iotData(obs_type);

/*WITH iot_statistics AS (
  SELECT *
    FROM [SHOW STATISTICS FOR TABLE iotData])
SELECT column_names,row_count,distinct_count,null_count
  FROM iot_statistics r
 WHERE created =(
        SELECT max(created)
     FROM iot_statistics
    WHERE column_names=r.column_names);


EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData
 WHERE country_code=1
   AND state_code=10;
 
EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData@iotState_ix
 WHERE country_code=1
   AND state_code=10;  
  
EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData
 WHERE obsDate BETWEEN NOW() - INTERVAL '1 YEAR' AND NOW()
   AND state_code=10; */
   
EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData
 WHERE obs_type=10
   AND state_code=10;
  
EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData@iotState_ix
 WHERE obs_type=10
   AND state_code=10;
  
EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData@iotType_ix
 WHERE obs_type=10
   AND state_code=10;
  
CREATE INDEX iotDataStateTypeMeas_ix ON iotData(obs_type,state_code) STORING(measurement);

EXPLAIN ANALYZE 
SELECT avg(measurement) 
  FROM iotData 
 WHERE obs_type=10
   AND state_code=10;
  
  

/*CREATE STATISTICS iot_country_state ON country_code, state_code FROM iotData;

WITH iot_statistics AS (
  SELECT *
    FROM [SHOW STATISTICS FOR TABLE iotData])
SELECT column_names,row_count,distinct_count,null_count
  FROM iot_statistics r
 WHERE created =(
        SELECT max(created)
     FROM iot_statistics
    WHERE column_names=r.column_names);
   
 EXPLAIN 
SELECT avg(measurement) 
  FROM iotData
 WHERE country_code=1
   AND state_code=10; */
  

   
   
   
   
 
           
