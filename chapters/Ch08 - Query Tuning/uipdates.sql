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

EXPLAIN ANALYZE
UPDATE USERS u 
   SET credit_card='9999804075' 
 WHERE city='rome' 
   AND name='Anna Massey' 
   AND address='75977 Donna Gateway Suite 52';
  
CREATE  INDEX users_city_name_add_cc_idx ON users(city,name,address) STORING(credit_card);

EXPLAIN ANALYZE
UPDATE USERS u 
   SET credit_card='9999804075' 
 WHERE city='rome' 
   AND name='Anna Massey' 
   AND address='75977 Donna Gateway Suite 52';
  
  DROP  INDEX users_city_name_add_cc_idx;
 
 CREATE  INDEX users_city_name_add_idx ON users(city,name,address);

EXPLAIN ANALYZE
UPDATE USERS u 
   SET credit_card='9999804075' 
 WHERE city='rome' 
   AND name='Anna Massey' 
   AND address='75977 Donna Gateway Suite 52';
  
 DROP INDEX users_city_name_add_idx ;

SELECT * FROM USERS u ORDER BY credit_card DESC LIMIT 10