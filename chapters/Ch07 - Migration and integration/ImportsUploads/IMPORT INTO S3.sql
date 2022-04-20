TRUNCATE TABLE departments;

IMPORT INTO  departments
   ( department_id,department_name,manager_id,location_id  )
   CSV DATA (
"s3://cockroachdefinitiveguide/departments.csv?AWS_ACCESS_KEY_ID=...2&AWS_SECRET_ACCESS_KEY=...") 
       WITH skip='1', nullif = '';