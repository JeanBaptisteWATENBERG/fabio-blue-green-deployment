#!/bin/sh
docker run -ti --net consul-network --rm --mount type=bind,source=$(pwd)/filebeat.yml,target=/usr/share/filebeat/filebeat.yml docker.elastic.co/beats/filebeat:6.5.1 bash

