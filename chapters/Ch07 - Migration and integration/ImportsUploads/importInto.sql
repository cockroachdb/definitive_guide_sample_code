  CREATE TABLE departments                                                                                                                                                                                                                            
   (    department_id integer PRIMARY KEY,                                                                                                                                                                                                                               
        department_name varchar,                                                                                                                                                                                 
        manager_id integer,
        location_id integer                                                                                                                                                                                                                                      
   ) ;

IMPORT INTO  departments
   ( department_id,department_name,manager_id,location_id  )
   CSV DATA ("userfile://defaultdb.public.userfiles_guy/departments.csv") 
       WITH skip='1', nullif = '';