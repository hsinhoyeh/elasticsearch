#! /bin/bash

DOCKER_TAG=elasticsearch:latest
ES_PATH=/tmp/elasticsearch

docker run -d \
 -p 9200:9200 \
 -p 9300:9300 \
 -v $ES_PATH:/data \
 elasticsearch:latest
