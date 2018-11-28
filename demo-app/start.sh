#!/bin/sh

set -x

./envsubst < consul-register.json > consul.json
curl -X PUT -d @consul.json http://$CONSUL:8500/v1/agent/service/register -v

pid=0

term_handler() {
  if [ $pid -ne 0 ]; then
    curl -X PUT http://$CONSUL:8500/v1/agent/service/deregister/python-test-${HOSTNAME} -v
    sleep 1 # wait for last requests to be processed - should definitely find a better way, indeed if treatment is longer it will still end up with 502 in extrem cases
    # we should tail access log and applicative logs and watch if something is happenning on the container, then wait for last access log entry
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap "kill ${!}; term_handler" 15
python3 -m http.server --bind 0.0.0.0 --cgi 8000 &> app.log &
pid="$!"

#tail -F app.log
# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
