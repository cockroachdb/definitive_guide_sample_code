\set display_format=table;

CREATE CHANGEFEED FOR TABLE movr.rides,movr.users  INTO 
     'kafka://localhost:9092' 
    WITH updated, resolved='120s';

\set display_format=records;

\set display_format=table;

CREATE CHANGEFEED FOR TABLE movr.rides,movr.users 
  INTO 'kafka://localhost:9092' 
  WITH format = experimental_avro, confluent_schema_registry = 'http://localhost:8081';

\set display_format=records;

SHOW JOB 679859316344848385

