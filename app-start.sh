#!/bin/sh
docker run --rm -d -e VERSION=docker --network=consul-network -e CONSUL=dev-consul --name=node-1 python-app
docker run --rm -d -e VERSION=docker --network=consul-network -e CONSUL=consul-agent-1 --name=node-2 python-app
docker run --rm -d -e VERSION=docker --network=consul-network -e CONSUL=consul-agent-2 --name=node-3 python-app
