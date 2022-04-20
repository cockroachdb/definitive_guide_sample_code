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

SELECT COUNT(*) 
  FROM vehicles v 
  JOIN rides r 
    ON (r.vehicle_id=v.id);
    
SELECT v.id,v.ext,r.start_time r.start_address 
  FROM vehicles v 
  LEFT OUTER JOIN rides r 
    ON (r.vehicle_id=v.id);
    
SELECT u.name , upc.code 
  FROM USERS u 
  JOIN user_promo_codes upc 
    ON (u.id=upc.user_id);
   
SELECT u.name , upc.code
  FROM USERS u 
  LEFT OUTER JOIN user_promo_codes upc 
    ON (u.id=upc.user_id);   
   
SELECT DISTINCT u.name , upc.code
  FROM user_promo_codes upc 
  RIGHT OUTER JOIN USERS u 
    ON (u.id=upc.user_id); 
   
 
SELECT city, user_id, code, "timestamp", usage_count
FROM public.user_promo_codes;

DROP TABLE employees;

CREATE TABLE employees AS 
 SELECT * FROM USERS LIMIT 10;


SELECT u.city,SUM(urc.rides),AVG(urc.rides),max(urc.rides)
  FROM users u 
  JOIN user_ride_counts urc 
 USING (name)
 GROUP BY u.city;
 
 

SELECT COUNT(*) FROM employees;

 SELECT *
  FROM users 
 WHERE id NOT IN 
       (SELECT id FROM employees)
       
 EXPLAIN SELECT *
   FROM users u
  WHERE NOT EXISTS 
        (SELECT id 
           FROM employees e
          WHERE e.id=u.id)
          
DROP TABLE customers;

CREATE TABLE customers AS SELECT * FROM USERS WHERE city <> 'boston';

SELECT *
   FROM users u
  WHERE NOT EXISTS 
        (SELECT id 
           FROM employees e
          WHERE e.id=u.id)
       
SELECT name, address 
  FROM customers
 MINUS 
SELECT name,address
  FROM employees;

SELECT name, address 
  FROM customers
 INTERSECT 
SELECT name,address
  FROM employees;
  
 SELECT name, address 
  FROM customers
 EXCEPT 
SELECT name,address
  FROM employees;
  
  SELECT name, address, start_time
   FROM USERS CROSS JOIN 
        LATERAL (SELECT * 
                   FROM rides 
                  WHERE rides.start_address = users.address ) r;
                  
WITH riderRevenue AS (
	  SELECT u.id, SUM(r.revenue) AS sumRevenue
	    FROM rides r JOIN "users" u 
	    ON (r.rider_id=u.id)
	   GROUP BY u.id)
SELECT * FROM "users" u2 
         JOIN riderRevenue rr USING (id)
 ORDER BY sumrevenue DESC 
 
 SELECT city,start_time, (end_time-start_time) duration
   FROM rides r
  ORDER BY city,(end_time-start_time)  DESC
  
CREATE INDEX rides_start_time ON rides (city ,start_time);
  
 USE movr 
 
SELECT city,start_time, (end_time-start_time) duration
  FROM rides
 ORDER BY INDEX rides@rides_start_time;
  
 CREATE TABLE ab(a INT, b INT, INDEX b_idx (b DESC, a ASC));
 
CREATE TABLE kv(k INT PRIMARY KEY, v INT, INDEX v_idx(v));
SELECT k, v FROM kv ORDER BY INDEX kv@v_idx;