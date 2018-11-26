#!/bin/sh

docker run -d --rm --name=dev-consul -e CONSUL_BIND_INTERFACE=eth0 -p 8500:8500 --network=consul-network consul
MASTER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' dev-consul)
docker run -d --rm --name=consul-agent-1 -e CONSUL_BIND_INTERFACE=eth0 --network=consul-network consul agent -dev -client=0.0.0.0 -join=$MASTER_IP
docker run -d --rm --name=consul-agent-2 -e CONSUL_BIND_INTERFACE=eth0 --network=consul-network consul agent -dev -client=0.0.0.0 -join=$MASTER_IP
docker exec -t dev-consul consul members
