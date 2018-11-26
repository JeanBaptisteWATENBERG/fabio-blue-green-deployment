#!/bin/sh
docker run -d --rm --name=fabio -p 9999:9999 -p 9998:9998 -p 8000:8000 -v $PWD/fabio/fabio.properties:/etc/fabio/fabio.properties --network=consul-network fabiolb/fabio

