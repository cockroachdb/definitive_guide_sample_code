rem Generate all DDL for the current user
set long 100000
set head off
set echo off
set pagesize 0
set verify off
set feedback off
col ddl format a256

REM These statements limit the amount of Oracle-specific clauses that are included in the output   
EXECUTE dbms_metadata.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM,'SEGMENT_CREATION',false);   
EXECUTE dbms_metadata.SET_TRANSFORM_PARAM(dbms_metadata.SESSION_TRANSFORM,'CONSTRAINTS_AS_ALTER',false);
EXECUTE dbms_metadata.set_transform_param(dbms_metadata.session_transform,'TABLESPACE',false);
EXECUTE dbms_metadata.set_transform_param(dbms_metadata.session_transform,'STORAGE',false);
EXECUTE dbms_metadata.set_transform_param(dbms_metadata.session_transform,'SEGMENT_ATTRIBUTES',false);
EXECUTE dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'SQLTERMINATOR', true);
EXECUTE dbms_metadata.set_transform_param (dbms_metadata.session_transform, 'PRETTY', true);

SELECT dbms_metadata.get_ddl('TABLE', table_name,user) AS  ddl FROM user_tables;
SELECT dbms_metadata.get_ddl('INDEX', index_name,user) AS  ddl FROM user_indexes;
SELECT dbms_metadata.get_ddl('VIEW',view_name,user) AS ddl FROM user_views;

EXIT

