CREATE DATABASE movrfeed;
CREATE TABLE movr (changefeed_record VARIANT);

CREATE STAGE cdc_stage url='s3://cockroachdefinitiveguide/movrFeed/' 
    credentials=(aws_key_id='0N4RRX7VG5WQS0Y0DTG2' 
    aws_secret_key='kLKkZjS/i98CN8oR6vp56lHC0ecgyf8zePCKd+aW') 
    file_format = (type = json);

CREATE PIPE cdc_pipe auto_ingest = TRUE as COPY INTO movr FROM @cdc_stage;