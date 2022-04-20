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

USE movr

DROP INDEX rides_start_time;

EXPLAIN   
SELECT start_address
FROM rides
WHERE city = 'paris'
ORDER BY start_time DESC
LIMIT 10;

EXPLAIN ANALYZE 
SELECT start_address
FROM rides
WHERE city = 'paris'
ORDER BY start_time DESC
LIMIT 10;

CREATE INDEX rides_start_time_address ON
rides(city, start_time) STORING (start_address);

EXPLAIN   
SELECT start_address
FROM rides
WHERE city = 'paris'
ORDER BY start_time DESC
LIMIT 10;

SET  cluster setting sql.distsql.temp_storage.workmem='64 MiB';

EXPLAIN analyze
SELECT vehicle_city, vehicle_id, sum(revenue)
FROM rides
GROUP BY vehicle_city, vehicle_id
ORDER BY 3 DESC
LIMIT 10;

CREATE INDEX rides_vc_vid_revenue ON rides(vehicle_city, vehicle_id ) STORING (revenue);

EXPLAIN analyze
SELECT vehicle_city, vehicle_id, sum(revenue)
FROM rides
GROUP BY vehicle_city, vehicle_id
ORDER BY 3 DESC
LIMIT 10;

DROP INDEX rides_vc_vid_revenue;
 
SET  cluster setting sql.distsql.temp_storage.workmem='500 MiB';

EXPLAIN ANALYZE
SELECT *
  FROM rides r
    INNER HASH JOIN USERS u
       ON (r.city=u.city AND r.rider_id=u.id)
    INNER HASH JOIN vehicles v
       ON (v.city=r.vehicle_city AND v.id=r.vehicle_id)
    LEFT OUTER HASH JOIN user_promo_codes upc
       ON (upc.city=u.city AND upc.user_id=u.id)
    LEFT OUTER  HASH JOIN promo_codes pc
       ON (upc.code=pc.code)
 ORDER BY r.city,v.TYPE,u.address,pc.description LIMIT 10;
;
EXPLAIN ANALYZE SELECT r.id
FROM rides AS r
WHERE (city, rider_id) 
NOT IN (SELECT city, user_id
FROM user_promo_codes AS upc);

 EXPLAIN ANALYZE 
 SELECT r.id FROM rides r
  WHERE NOT EXISTS (
       SELECT city,user_id 
         FROM user_promo_codes upc
        WHERE upc.city=r.city
          AND upc.user_id=r.rider_id)
          ;
          
EXPLAIN ANALYZE
SELECT r.id 
  FROM rides r 
  LEFT OUTER JOIN user_promo_codes upc
        ON (upc.city=r.city
          AND upc.user_id=r.rider_id)
 WHERE upc.user_id IS NULL;         