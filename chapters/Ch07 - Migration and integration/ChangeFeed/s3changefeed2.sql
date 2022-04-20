@set accessKey = '...'
@set secretKey = '...' 
CREATE CHANGEFEED FOR TABLE movr.rides,movr.users,movr.vehicles INTO 
    CONCAT('experimental-s3://example-bucket-name/test?AWS_ACCESS_KEY_ID=',
    '${accessKey}',
    '&AWS_SECRET_ACCESS_KEY=',
    '${secretKey}'
    WITH updated, resolved='10s';