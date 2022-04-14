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

ALTER TABLE employees ADD manager_id uuid;
SELECT * FROM employees;
UPDATE employees e SET manager_id=(SELECT max(id) FROM employees e1 WHERE e1.city=e.city); 
UPDATE employees e SET manager_id=(SELECT  id FROM employees e1 WHERE name='Jennifer Sanders' ) WHERE name='Cindy Medina';
UPDATE employees e SET manager_id=NULL WHERE manager_id=id;
SELECT * FROM employees;

WITH RECURSIVE employeeMgr AS (
  SELECT id,manager_id, name , NULL AS manager_name, 1 AS level
    FROM employees managers 
   WHERE manager_id IS NULL  
  UNION ALL 
  SELECT subordinates.id,subordinates.manager_id,
         subordinates.name, managers.name ,managers.LEVEL+1
    FROM employeeMgr managers
    JOIN employees subordinates 
      ON (subordinates.manager_id=managers.id)
)
SELECT * FROM employeeMgr 
ORDER BY level