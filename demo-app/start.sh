#!/bin/sh

set -x

./envsubst < consul-register.json > consul.json
curl -X PUT -d @consul.json http://$CONSUL:8500/v1/agent/service/register -v

pid=0

term_handler() {
  if [ $pid -ne 0 ]; then
    curl -X PUT http://$CONSUL:8500/v1/agent/service/deregister/python-test-${HOSTNAME} -v
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

trap term_handler 15
python3 -m http.server --bind 0.0.0.0 --cgi 8000 &> app.log &
pid="$!"

# tail -F app.log
# wait forever
while true
do
  tail -f /dev/null & wait ${!}
done
