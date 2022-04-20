# Generating and applying encryption keys
cockroach gen encryption-key -s 128 $HOME/.cockroachKeys/crdb-aes-128.key


cockroach start-single-node --store=/var/lib/cockroachdb/encrypted-cockroach-data --enterprise-encryption=path=/var/lib/cockroachdb/encrypted-cockroach-data,key=/home/cockroachdb/.cockroachKeys/crdb-aes-128.key,old-key=plain --certs-dir=/var/lib/cockroachdb/certs 

cockroach gen encryption-key -s 128 $HOME/.cockroachKeys/new-crdb-aes-128.key

cockroach start-single-node --store=/var/lib/cockroachdb/encrypted-cockroach-data --enterprise-encryption=path=/var/lib/cockroachdb/encrypted-cockroach-data,key=/home/cockroachdb/.cockroachKeys/new-crdb-aes-128.key,old-key=/home/cockroachdb/.cockroachKeys/crdb-aes-128.key --certs-dir=/var/lib/cockroachdb/certs 