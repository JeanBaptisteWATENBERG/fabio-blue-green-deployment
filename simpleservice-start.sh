#!/bin/sh
docker build -t simpleservice simple-service-war
docker run -d --name simpleservice-run-insatance-1 --network=consul-network -e CONSUL=dev-consul -e INSTANCE=1 --rm -p 8887:8080 simpleservice
docker run -d --name simpleservice-run-insatance-2 --network=consul-network -e CONSUL=consul-agent-1 -e INSTANCE=2 --rm -p 8888:8080 simpleservice
docker run -d --name simpleservice-run-insatance-3 --network=consul-network -e CONSUL=consul-agent-2 -e INSTANCE=3 --rm -p 8889:8080 simpleservice