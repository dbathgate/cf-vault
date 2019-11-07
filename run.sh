#!/bin/bash

MYSQL_EXISTS=$(echo $VCAP_SERVICES | jq '.["p.mysql"]')

if [ $MYSQL_EXISTS = null ]; then

   echo "MySQL Service not bound..."
   echo "Running vault in dev mode..."
   exec ./vault server -dev -dev-listen-address=${CF_INSTANCE_INTERNAL_IP}:8080

else

    DB_HOST=$(echo $VCAP_SERVICES | jq '.["p.mysql"][0].credentials.hostname')
    DB_NAME=$(echo $VCAP_SERVICES | jq '.["p.mysql"][0].credentials.name')
    DB_USERNAME=$(echo $VCAP_SERVICES | jq '.["p.mysql"][0].credentials.username')
    DB_PASSWORD=$(echo $VCAP_SERVICES | jq '.["p.mysql"][0].credentials.password')

    cp vault-template.conf vault.conf

    sed -i -e "s/%USERNAME%/$DB_USERNAME/g" vault.conf
    sed -i -e "s/%PASSWORD%/$DB_PASSWORD/g" vault.conf
    sed -i -e "s/%ADDRESS%/$DB_HOST/g" vault.conf
    sed -i -e "s/%DATABASE%/$DB_NAME/g" vault.conf
    sed -i -e "s/%IP_ADDRESS%/$CF_INSTANCE_INTERNAL_IP/g" vault.conf

    exec ./vault server -config=./vault.conf

fi