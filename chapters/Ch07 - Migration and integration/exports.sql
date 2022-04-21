EXPORT INTO CSV 'nodelocal://self/rides.csv' WITH nullas='' FROM TABLE rides;

EXPORT INTO CSV 
<<<<<<< HEAD
"s3://cockroachdefinitiveguide/?AWS_ACCESS_KEY_ID=${key}&AWS_SECRET_ACCESS_KEY=${key}" 
=======
"s3://cockroachdefinitiveguide/?AWS_ACCESS_KEY_ID=0N4RRX7VG5WQS0Y0DTG2&AWS_SECRET_ACCESS_KEY=kLKkZjS/i98CN8oR6vp56lHC0ecgyf8zePCKd+aW" 
>>>>>>> 07638645ca5da12c42dcee9ffd3b9706eaa51e8b
WITH nullas='' FROM TABLE rides;

EXPORT INTO CSV 
'userfile://defaultdb.public.userfiles_guy/'
WITH nullas='' FROM  SELECT rider_id,start_time,end_time FROM rides WHERE city='amsterdam';