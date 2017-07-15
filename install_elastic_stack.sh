#!/bin/bash

ESGR=`grep elasticstack /etc/group`
if [ "x$ESGR" == "x" ]; then
  groupadd elasticstack
fi;

# ******** ELASTICSEARCH
ES_USER_EXISTS=`getent passwd | grep elasticsearch`

if [ "x$ES_USER_EXISTS" == "x" ]; then
  useradd -r -g elasticstack --no-create-home  elasticsearch
fi;

#wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.5.0.zip

unzip -q elasticsearch-5.5.0.zip
mv elasticsearch-5.5.0 elasticsearch

chown -R elasticsearch:elasticstack elasticsearch

export ES_NETWORK_HOST=0.0.0.0
sed -i -e 's/#network.host: 192.168.0.1/#network.host: \${ES_NETWORK_HOST}/g' elasticsearch/config/elasticsearch.yml
sysctl -w vm.max_map_count=262144 > /dev/null

su - elasticsearch -c '/opt/elasticsearch/bin/elasticsearch -d'


# ********** ZOOKEEPER
USER_EXISTS=`getent passwd | grep zookeeper`

if [ "x$ES_USER_EXISTS" == "x" ]; then
  useradd -r -g elasticstack --no-create-home zookeeper
fi;

#wget http://ftp.unicamp.br/pub/apache/zookeeper/zookeeper-3.4.10/zookeeper-3.4.10.tar.gz

tar xfz zookeeper-3.4.10.tar.gz

mv zookeeper-3.4.10 zookeeper
mv zookeeper/conf/zoo_sample.cfg zookeeper/conf/zoo.cfg

chown -R zookeeper:elasticstack zookeeper

su - zookeeper -c 'export ZOO_LOG_DIR=/tmp; /opt/zookeeper/bin/zkServer.sh start'

# +++++++ KAFKA

#wget http://ftp.unicamp.br/pub/apache/kafka/0.11.0.0/kafka_2.12-0.11.0.0.tgz

tar xfz kafka_2.12-0.11.0.0.tgz

mv kafka_2.12-0.11.0.0 kafka


#wget https://artifacts.elastic.co/downloads/logstash/logstash-5.5.0.tar.gz
#wget https://artifacts.elastic.co/downloads/kibana/kibana-5.5.0-linux-x86_64.tar.gz
