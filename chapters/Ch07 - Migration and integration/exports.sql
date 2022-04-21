EXPORT INTO CSV 'nodelocal://self/rides.csv' WITH nullas='' FROM TABLE rides;

EXPORT INTO CSV 
"s3://cockroachdefinitiveguide/?AWS_ACCESS_KEY_ID=${key}&AWS_SECRET_ACCESS_KEY=${key}" 
WITH nullas='' FROM TABLE rides;

EXPORT INTO CSV 
'userfile://defaultdb.public.userfiles_guy/'
WITH nullas='' FROM  SELECT rider_id,start_time,end_time FROM rides WHERE city='amsterdam';