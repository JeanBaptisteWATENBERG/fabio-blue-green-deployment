#!/bin/sh
docker run --rm -d --name kibana -v $(pwd)/kibana.yml:/usr/share/kibana/config/kibana.yml --net consul-network -p 5601:5601 kibana:6.5.1
