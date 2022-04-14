export CLASSPATH="/Users/guyharrison/OneDrive/CockroachDBTDG/cockroachDB-tdg/manuscript/Ch03 Getting Started/examples/Java/helloCockroach/postgresql-42.2.20.jar"
cd /Users/guyharrison/eclipse-workspace/helloCRDB/bin
java -p . -m helloCRDB/helloCRDB.HelloCRDB postgresql://localhost:26257/?sslmode=disable root ''

java -p . -m  helloCRDB/helloCRDB.HelloCRDB 'postgresql://free-tier6.gcp-asia-southeast1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full&sslrootcert=/Users/guyharrison/CRDBKeys/cc-ca.crt&options=--cluster%3Dgrumpy-orca-56' guy ***REMOVED*** 