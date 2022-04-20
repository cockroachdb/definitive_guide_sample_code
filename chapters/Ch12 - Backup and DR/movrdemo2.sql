 SELECT raw_config_sql FROM crdb_internal.zones 
  WHERE target='RANGE default';
SHOW RANGE FROM INDEX users@primary  FOR ROW ('amsterdam','ae147ae1-47ae-4800-8000-000000000022');

show databases;
show regions;

ALTER DATABASE movr PRIMARY REGION "gcp-us-east1" ;
ALTER DATABASE movr ADD REGION  "gcp-europe-west1";
ALTER DATABASE movr ADD REGION "gcp-us-west1";

\set display_format=records;
show regions;

show databases;

 SELECT raw_config_sql FROM crdb_internal.zones 
  WHERE target='DATABASE movr';

SELECT name,locality 
  FROM crdb_internal."tables" 
 WHERE schema_name='public' 
   AND database_name='movr';
 
 SELECT city,id FROM users LIMIT 1;
\set display_format=records;
SHOW RANGE FROM INDEX users@primary  FOR ROW ('amsterdam','ae147ae1-47ae-4800-8000-000000000022');
\set display_format=table;

ALTER TABLE users DROP COLUMN crdb_region;

ALTER TABLE users ADD COLUMN crdb_region crdb_internal_region AS (
  CASE
    WHEN city IN ('new york', 'boston', 'washington dc') THEN 'gcp-us-east1'
    WHEN city IN ('san francisco', 'seattle', 'los angeles') THEN 'gcp-us-west1'
    WHEN city IN ('amsterdam', 'paris', 'rome') THEN 'gcp-europe-west1'  
    ELSE 'gcp-us-east1'
  END
) STORED;

SELECT DISTINCT city,crdb_region FROM users;

ALTER TABLE users ALTER COLUMN crdb_region SET NOT NULL;

ALTER TABLE users SET LOCALITY REGIONAL BY ROW;
\set display_format=records;
SELECT  job_type,description,status 
  FROM [show jobs] 
 WHERE description LIKE '%REGIONAL%';
 \set display_format=table;

ALTER TABLE rides ADD COLUMN crdb_region crdb_internal_region AS (
  CASE
    WHEN city IN ('new york', 'boston', 'washington dc') THEN 'gcp-us-east1'
    WHEN city IN ('san francisco', 'seattle', 'los angeles') THEN 'gcp-us-west1'
    WHEN city IN ('amsterdam', 'paris', 'rome') THEN 'gcp-europe-west1'  
    ELSE 'gcp-us-east1'
  END
) STORED;
 
ALTER TABLE rides ALTER COLUMN crdb_region SET NOT NULL;

ALTER TABLE rides SET LOCALITY REGIONAL BY ROW;

ALTER TABLE vehicles ADD COLUMN crdb_region crdb_internal_region AS (
  CASE
    WHEN city IN ('new york', 'boston', 'washington dc') THEN 'gcp-us-east1'
    WHEN city IN ('san francisco', 'seattle', 'los angeles') THEN 'gcp-us-west1'
    WHEN city IN ('amsterdam', 'paris', 'rome') THEN 'gcp-europe-west1'  
    ELSE 'gcp-us-east1'
  END
) STORED;
 
ALTER TABLE vehicles ALTER COLUMN crdb_region SET NOT NULL;

ALTER TABLE vehicles SET LOCALITY REGIONAL BY ROW;

ALTER TABLE vehicle_location_histories ADD COLUMN crdb_region crdb_internal_region AS (
  CASE
    WHEN city IN ('new york', 'boston', 'washington dc') THEN 'gcp-us-east1'
    WHEN city IN ('san francisco', 'seattle', 'los angeles') THEN 'gcp-us-west1'
    WHEN city IN ('amsterdam', 'paris', 'rome') THEN 'gcp-europe-west1'  
    ELSE 'gcp-us-east1'
  END
) STORED;
 
ALTER TABLE vehicle_location_histories ALTER COLUMN crdb_region SET NOT NULL;

ALTER TABLE vehicle_location_histories SET LOCALITY REGIONAL BY ROW;

ALTER TABLE user_promo_codes ADD COLUMN crdb_region crdb_internal_region AS (
  CASE
    WHEN city IN ('new york', 'boston', 'washington dc') THEN 'gcp-us-east1'
    WHEN city IN ('san francisco', 'seattle', 'los angeles') THEN 'gcp-europe-west1'
    WHEN city IN ('amsterdam', 'paris', 'rome') THEN 'gcp-europe-west1'  
    ELSE 'gcp-us-east1'
  END
) STORED;
 
ALTER TABLE user_promo_codes ALTER COLUMN crdb_region SET NOT NULL;

ALTER TABLE user_promo_codes SET LOCALITY REGIONAL BY ROW;

select description,status from [show jobs] where description like '%REGIONAL%';

ALTER TABLE promo_codes SET LOCALITY GLOBAL;


\set display_format=table;
SELECT DISTINCT index_name,column_Name 
  FROM crdb_internal.index_columns  
 WHERE descriptor_name='users';

select crdb_region,city,id from users limit 1;
\set display_format=records;
SHOW RANGE FROM INDEX users@primary FOR ROW ('gcp-us-east1','new york','00000000-0000-4000-8000-000000000000');
SHOW RANGE FROM INDEX users@primary FOR ROW ('gcp-europe-west1','amsterdam','ae147ae1-47ae-4800-8000-000000000022');
\set display_format=table;

ALTER DATABASE movr SURVIVE REGION FAILURE;
\set display_format=records;
select description,status from [show jobs] where description like '%SURVIVE%';

\set display_format=records;

show range from index users@primary for row ('gcp-europe-west1','amsterdam','ae147ae1-47ae-4800-8000-000000000022');
\set display_format=table;