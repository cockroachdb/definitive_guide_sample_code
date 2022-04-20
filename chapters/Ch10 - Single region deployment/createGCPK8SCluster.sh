 

gcloud container clusters create crdb --zone=us-central1-c  --machine-type n2-standard-4 --disk-type=pd-ssd --disk-size=200GB --project=just-rhythm-211204


gcloud container clusters get-credentials crdb --zone us-central1-c --project=just-rhythm-211204
kubectl get nodes

kubectl apply -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/config/crd/bases/crdb.cockroachlabs.com_crdbclusters.yaml


rm operator.yaml
wget https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/manifests/operator.yaml 

# Change namespace, etc
kubectl apply -f operator.yaml

kubectl get pods

rm example.yaml
wget https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/examples/example.yaml
#Edit it
kubectl create -f example.yaml

#Add another pod running the client 

kubectl create -f https://raw.githubusercontent.com/cockroachdb/cockroach-operator/master/examples/client-secure-operator.yaml

# Connect 

kubectl exec -it cockroachdb-client-secure \
-- ./cockroach sql \
--certs-dir=/cockroach/cockroach-certs \
--host=cockroachdb-public


kubectl apply -f loadBalancer.yaml

kubectl get service cockroach-lb-service

rm -rf certs
mkdir certs 
kubectl exec cockroachdb-0 -it -- cat cockroach-certs/ca.crt >certs/ca.crt
chmod 600 certs/*

cockroach sql --url 'postgres://guy:password@104.197.158.47:26257?sslmode=verify-ca&sslrootcert=certs/ca.crt'