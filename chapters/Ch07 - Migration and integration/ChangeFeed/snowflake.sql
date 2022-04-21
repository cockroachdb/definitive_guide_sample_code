CREATE DATABASE movrfeed;
CREATE TABLE movr (changefeed_record VARIANT);

CREATE STAGE cdc_stage url='s3://cockroachdefinitiveguide/movrFeed/' 
    credentials=(aws_key_id='' 
    aws_secret_key='kLKkZjS/+aW') 
    file_format = (type = json);

CREATE PIPE cdc_pipe auto_ingest = TRUE as COPY INTO movr FROM @cdc_stage;