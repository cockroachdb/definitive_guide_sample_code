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

Some queries against the crdb_internal views

*/

SELECT node_id, current_timestamp AT time ZONE 'UTC'- START run_time, 
 user_name, QUERY, phase
FROM SYSTEM.crdb_internal.cluster_queries
ORDER BY START
LIMIT 10;

SELECT KEY, count, service_lat_avg, count::float * service_lat_avg sum_service
FROM crdb_internal.node_statement_statistics
ORDER BY count::float * service_lat_avg DESC
LIMIT 10

WITH txn_statements AS (SELECT KEY, unnest(statement_ids) statement_id,max_retries,contention_time_avg FROM crdb_internal.node_transaction_statistics)
SELECT * FROM txn_statements ts JOIN  crdb_internal.node_queries q ON (ts.statement_id=q.QUERY_id) ORDER BY max_retries desc,contention_time_avg DESC 

SELECT * from crdb_internal.node_queries WHERE query_id='1288264448111598659'