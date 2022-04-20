SELECT raw_config_sql FROM crdb_internal.zones
  WHERE target='RANGE default';
 
ALTER RANGE default CONFIGURE ZONE USING
    num_replicas=5;

    \set display_format=records;
SELECT  job_type,description,status 
  FROM [show jobs] 
 