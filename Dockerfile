#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

# Pull base image.
FROM java:7

ENV ES_PKG_NAME elasticsearch-2.1.1
ENV HOME /eshome

RUN mkdir $HOME
RUN chown nobody $HOME

# since in 2.1.1 we cannot run es with root. just run with nobody
USER nobody

# Install Elasticsearch.
RUN wget -P $HOME https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.1.1/$ES_PKG_NAME.tar.gz
RUN cd $HOME && \
    tar xvzf $ES_PKG_NAME.tar.gz && \
    rm -f $ES_PKG_NAME.tar.gz && \
    mv $ES_PKG_NAME elasticsearch

# Define mountable directories.
VOLUME ["/eshome/data"]

# Mount elasticsearch.yml config
ADD config/elasticsearch.yml ~/elasticsearch/config/elasticsearch.yml

# Define working directory.
WORKDIR /eshome/data

# Define default command.
CMD ["../elasticsearch/bin/elasticsearch"]

# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300
