
set head on
set echo off
set pagesize 0
set verify off
set feedback off
set sqlformat csv 

ALTER SESSION SET nls_date_format = 'YYYY-MM-DD HH24:MI:SS';

select  * from &1;

exit