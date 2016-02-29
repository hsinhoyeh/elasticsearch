#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM java:7

ENV ES_PKG_NAME elasticsearch-2.1.1
ENV HOME /eshome
ENV ES_HOME /eshome/elasticsearch
ENV ES_DATA /data

# Install Elasticsearch.
RUN wget -P $HOME https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/$ES_PKG_NAME.tar.gz
RUN cd $HOME && \
    tar xvzf $ES_PKG_NAME.tar.gz && \
    rm -f $ES_PKG_NAME.tar.gz && \
    mv $ES_PKG_NAME elasticsearch
# Install offline
#ADD elasticsearch-2.1.1.tar.gz $HOME/
#RUN mv $HOME/elasticsearch-2.1.1 $ES_HOME

RUN mkdir -p $ES_HOME && \
    mkdir -p $ES_HOME/plugins && \
    mkdir -p $ES_HOME/config

# allocate datafolder
RUN mkdir -p $ES_DATA && \
    mkdir -p $ES_DATA/data && \
    mkdir -p $ES_DATA/work && \
    mkdir -p $ES_DATA/log

# Define mountable directories.
VOLUME ["/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml $ES_HOME/config/elasticsearch.yml

# install plugins
# 1 .license
# 2. shield pkg
RUN \
    $ES_HOME/bin/plugin install elasticsearch/license/latest && \
    $ES_HOME/bin/plugin install elasticsearch/shield/latest

# Add a script to setup environment before we run
ADD docker-entrypoint-override.sh docker-entrypoint-override.sh
RUN chmod +x docker-entrypoint-override.sh

# Define working directory.
WORKDIR $ES_HOME

# Define default command.
CMD ["/docker-entrypoint-override.sh"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
