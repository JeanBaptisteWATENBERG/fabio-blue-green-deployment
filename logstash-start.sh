#!/bin/sh
docker run --rm --name logstash-1 -d -e CONSUL=dev-consul --net consul-network -v $(pwd)/logstash/pipeline/:/usr/share/logstash/pipeline logstash-consul
docker run --rm --name logstash-2 -d -e CONSUL=consul-agent-1 --net consul-network -v $(pwd)/logstash/pipeline/:/usr/share/logstash/pipeline logstash-consul
docker run --rm --name logstash-3 -d -e CONSUL=consul-agent-2 --net consul-network -v $(pwd)/logstash/pipeline/:/usr/share/logstash/pipeline logstash-consul

