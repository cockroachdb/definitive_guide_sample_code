/* 
CockroachDB the Definitive Guide sample code 
This code  is public domain software, i.e. not copyrighted.

Warranty Exclusion
------------------
You agree that this software is a non-commercially developed program that may 
contain "bugs"   and that it may not function as intended.
The software is licensed "as is". The authors make no, and hereby expressly
disclaim all, warranties, express, implied, statutory, or otherwise
with respect to the software, including noninfringement and the implied
warranties of merchantability and fitness for a particular purpose.

@author:  gharriso (guy.a.harrison@gmail.com)
*/

/* Using a CTE to generate random data */

SELECT * FROM baseData;

CREATE TABLE baseData AS 
/* Thanks: https://gist.github.com/kovid-r/736bdbd4ad75924fe99b102978525fd6 */
with recursive series as (
	select 1 as id union all
	select id + 1 as id
   from series
   where id < 100), 
   		cities as (select 'Santa Clara' city union all 
   		           select 'Los Angeles' union all 
   		           select 'Santa Clarita' union all 
   		           select 'San Bernardino' union all
   		           select 'Alameda' union all
   		           select 'San Mateo' union all 
   		           select 'Santa Barbara'   		           
   		          ),
   		first_names as (select 'John' first_name union all
   				select 'James' first_name union all
   				select 'David' first_name union all
   				select 'Jeremy' first_name union all
   				select 'Ron' first_name union all
   				select 'Katie' first_name union all
   				select 'Nikita' first_name union all
   				select 'Rachel' first_name union all
   			        select 'Tom' first_name	
   		),
   	 	last_names as (select 'Smith' last_name union all
			       select 'Johnson' last_name union all
   			       select 'Williams' last_name union all
   			       select 'Brown' last_name union all
   			       select 'Jones' last_name union all
   		               select 'Miller' last_name union all
   			       select 'Davis' last_name union all
   			       select 'Wilson' last_name union all
   			      select 'West' last_name	
   		)
select id, user_id, first_name, last_name
       dob, city, salary - mod(salary, 100) salary
from (select id, 
       substring(md5(random()::STRING),1,20) user_id,
       (select first_name from first_names order by random() limit 1) first_name,
       (select last_name from last_names order by random() limit 1) last_name,
       CAST(concat(floor(1919+random()*100)::STRING,'-',floor(1+random()*12)::STRING,'-',floor(1+random()*28)::STRING) AS date) dob,
       (select city from cities order by random() limit 1) city,
       floor((random()::int * (120000 + 1)) + 35000) salary
from series) as t;

with recursive series as (
	select 1 as id union all
	select id + 1 as id
   from series
   where id < 100)
  SELECT id,random() rnumber, md5(random()::STRING) rstring FROM series
SELECT random(),random(),random()