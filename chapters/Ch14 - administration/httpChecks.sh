# Using the http interfaces to check status

curl --insecure https://gubuntu1.local:8080/health?ready=1

curl https://admin-zesty-camel-7hp.cockroachlabs.cloud:8080/health?ready=1

curl --insecure https://gubuntu1.local:8080/_status/vars |head -10

curl -d "username=guyballs&password=thx1138" \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    https://gubuntu1.local:8080/api/v2/login/   

    

export USERNAME=guyballs
export PASSWORD=thx1138

curl -d "username=${USERNAME}&password=${PASSWORD}" \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --cacert $HOME/cockroach/certs/ca.crt \
    https://gubuntu1.local:8080/api/v2/login/   

curl -d "username=$USERNAME&password=$PASSWORD" \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --insecure \
    https://gubuntu1.local:8080/api/v2/login/   


export TOKEN=`curl -d "username=guyballs&password=thx1138" \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --cacert $HOME/cockroach/certs/ca.crt \
    https://gubuntu1.local:8080/api/v2/login/  |jq '.session'` 

curl --request GET \
  --url 'https:/gubuntu1.local:8080/api/v2/nodes/' \
  --cacert $HOME/cockroach/certs/ca.crt \
  --header 'X-Cockroach-API-Session: CIGAhJ7p153gCRIQvCerkilIMUfjcS1M/uJHmA=='|jq