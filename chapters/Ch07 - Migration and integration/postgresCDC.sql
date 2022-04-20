// SET wal_level='logical' IN postgres.conf
show max_replication_slots;
show wal_level;


SELECT * FROM rental;

SELECT * FROM pg_create_logical_replication_slot('CockroachMigration', 'wal2json');

SELECT * FROM pg_create_logical_replication_slot('pgoutput', 'pgoutput');
SELECT * FROM pg_logical_slot_peek_changes('pgoutput', NULL, NULL);

INSERT INTO rental (rental_date,inventory_id,customer_id,staff_id,last_update)
  SELECT now(), inventory_id, customer_id,staff_id, last_update FROM rental WHERE rental_id=1;
  
SELECT * FROM pg_logical_slot_get_changes('rental_cdc', NULL, NULL);

 SELECT * FROM pg_drop_replication_slot('cockroach_migration');

 INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
SELECT   now(), inventory_id, customer_id, return_date, staff_id, now()
FROM public.rental LIMIT 10;