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
\set prompt1=%/>
\set display_format=records
USE movr 

EXPLAIN (VERBOSE) SELECT *
FROM rides
WHERE end_address = '66037 Belinda Plaza Apt. 93';

EXPLAIN SELECT *
FROM rides
WHERE end_address = '66037 Belinda Plaza Apt. 93'
AND city = 'amsterdam';

EXPLAIN SELECT rider_id
FROM rides
WHERE vehicle_id = 'aaaaaaaa-aaaa-4800-8000-00000000000a'
AND vehicle_city = 'amsterdam'
AND end_address = '63002 Sheila Fall';

EXPLAIN SELECT *
FROM rides r
JOIN vehicles v ON
      (r.vehicle_city = v.city
	AND r.vehicle_id = v.id)
WHERE vehicle_id = 'aaaaaaaa-aaaa-4800-8000-00000000000a'
AND vehicle_city = 'amsterdam'
AND end_address = '63002 Sheila Fall'
ORDER BY start_address;

EXPLAIN SELECT rider_id, start_address
FROM rides r
WHERE vehicle_id = 'aaaaaaaa-aaaa-4800-8000-00000000000a'
AND vehicle_city = 'amsterdam'
AND end_address = '63002 Sheila Fall'
ORDER BY start_address;




CREATE INDEX rides_vehicle_address_rider_ix1 
    ON rides(vehicle_city,vehicle_id,end_address) 
STORING (rider_id); 

DROP INDEX rides_vehicle_address_rider_ix1 ;

EXPLAIN SELECT rider_id
FROM rides
WHERE vehicle_id = 'aaaaaaaa-aaaa-4800-8000-00000000000a'
AND vehicle_city = 'amsterdam'
AND end_address = '63002 Sheila Fall';

EXPLAIN (verbose) SELECT *
FROM rides
WHERE end_address = '63002 Sheila Fall';

EXPLAIN SELECT *
FROM rides
WHERE end_address = '63002 Sheila Fall';

EXPLAIN (OPT, VERBOSE) SELECT *
FROM rides r
JOIN vehicles v ON
      (r.vehicle_city = v.city
	AND r.vehicle_id = v.id)
WHERE vehicle_id = 'aaaaaaaa-aaaa-4800-8000-00000000000a'
AND vehicle_city = 'amsterdam'
AND end_address = '63002 Sheila Fall'
ORDER BY start_address;

EXPLAIN (OPT, verbose) 
SELECT start_address
FROM rides
WHERE vehicle_city = 'amersterdam'
AND city = 'amsterdam'
AND rider_id = 'ee060ca6-c8a8-460c-b723-ec5e5fb3ac1b'
AND vehicle_id = '86a111c3-b0ca-4502-b119-2544909ed93e';

EXPLAIN (DISTSQL) SELECT *
FROM rides
WHERE end_address = '63002 Sheila Fall';

EXPLAIN (DISTSQL) SELECT *
FROM rides
WHERE city='new york'
  AND end_address = '63002 Sheila Fall';

EXPLAIN (OPT,VERBOSE) 
SELECT start_address
FROM rides
WHERE end_address = '63002 Sheila Fall';

EXPLAIN ANALYZE SELECT *
FROM rides r
JOIN vehicles v ON
      (r.vehicle_city = v.city
	AND r.vehicle_id = v.id)
WHERE vehicle_id = '86a111c3-b0ca-4502-b119-2544909ed93e'
AND vehicle_city = 'amsterdam'
ORDER BY start_address;

SELECT v.id, r.end_address, r.start_time
FROM rides
LIMIT 10;

EXPLAIN ANALYZE  
SELECT v.id, r.end_address, r.start_time
FROM vehicles v
JOIN rides r ON
(r.vehicle_id = v.id)
WHERE v.ext@> '{"brand":"Fuji"}'
AND v.city = 'paris'
AND v.status = 'in_use';

EXPLAIN ANALYZE (PLAN,DEBUG) 
SELECT v.id, r.end_address, r.start_time
FROM vehicles v
JOIN rides r ON
(r.vehicle_id = v.id)
WHERE v.ext@> '{"brand":"Fuji"}'
AND v.city = 'paris'
AND v.status = 'in_use';

EXPLAIN ANALYZE   
SELECT *
FROM vehicles v
WHERE v.ext@> '{"brand":"Fuji"}'
AND v.city = 'paris'
AND v.status = 'in_use';

EXPLAIN ANALYZE
SELECT *
FROM vehicles v
WHERE v.ext@> '{"brand":"Fuji"}'
AND v.city = 'paris'
AND v.status = 'in_use';

