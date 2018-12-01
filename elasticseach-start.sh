#!/bin/sh

docker run -d --name elasticsearch --net consul-network -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" elasticsearch:6.5.1
