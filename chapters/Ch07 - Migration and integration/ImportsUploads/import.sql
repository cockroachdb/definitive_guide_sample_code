DROP TABLE departments;

IMPORT TABLE  departments
    (   department_id integer PRIMARY KEY,                                                                                                                                                                                                                               
        department_name varchar,                                                                                                                                                                                 
        manager_id integer,
        location_id integer )
   CSV DATA ("userfile://defaultdb.public.userfiles_guy/departments.csv") 
       WITH skip='1', nullif = '';