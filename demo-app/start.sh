#!/bin/sh
export VERSION=$1
./envsubst < consul-register.json > consul.json
curl -X PUT -d @consul.json http://$CONSUL:8500/v1/agent/service/register -v
python3 -m http.server --bind 0.0.0.0 --cgi 8000
