#!/bin/bash
set -e

# TODO: check user exist or not
# use /eshome/elasticsearch/bin/shield/esusers list

# TODO: add audit configuration
# https://www.elastic.co/guide/en/shield/current/configuring-auditing.html
ES_USER=es_user
ES_PASS=password

echo "removing default users..."
rm -fv $ES_HOME/config/shield/users*
echo "adding user with admin role..."
$ES_HOME/bin/shield/esusers useradd $ES_USER -p $ES_PASS -r admin

# FIXME(hsinho): --network.host _non_loopback_ is used to workaround the issue
# ref: https://github.com/docker-library/elasticsearch/issues/52

useradd -d /home/esuser -u 1002 -p "esuser" -m -s /bin/bash esuser
chown -R 1002 $ES_DATA
chown -R 1002 $ES_HOME

# run elasticserach
# since in 2.1.1 we cannot run es with root. just run with csirun
su esuser -c '$ES_HOME/bin/elasticsearch --network.host _non_loopback_'
