# Fabio - Playground

This repository contains a playground environment to experiment Fabio in different context.
The original goal was to search a fix for 502 status code got when a docker stack was redeploying. A solution to this issue is explained in Blue Green Deployment section.
This environment was then reused to test logstash integration behind fabio with the idea to test such integration in the simplest possible way.

<details>
  <summary>Blue Green deployment</summary>

## Blue Green deployment

As stated in the introduction, we were facing 502 status codes when redeploying a docker stack behind fabio. We rapidly identified that it came from the fact that consul healthcheck weren't updated when the deployment occcurred. 
I oppenned an issue https://github.com/fabiolb/fabio/issues/578 on fabio repository and then studied the implementation of the solution in this repository.
The simplest solution in our case would be to unregister the service from consul when receiving a SIGTERM.

An implementation of this solution can be found here : [/demo-app/start.sh](/demo-app/start.sh)

```
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
START_YOUR_APP_HERE_IN_BACKGROUD &
pid="$!"

#tail -F app.log
# wait forever
while true
do
  tail -f /dev/null & wait ${!}

```

### Components

 - Developement consul cluster of 3 dockerized nodes
 - A single dockerized fabio node
 - 3 applicative nodes registered in consul
 - A monitoring script to check behavior of the application, it will send a notification if the application respond with a status code >= 500

### Steps to run the experiment

Steps :

 - create docker network : ./create-network.sh
 - Start consul : ./consul-cluster-start.sh
 - Start fabio : ./fabio-start.sh
 - build python demo app : docker build -t python-app demo-app
 - Run the app : ./app-start.sh
 - Run the monitoring script : ./app-monitor.sh
</details>
<details>
<summary>Logstash behind fabio</summary>

## Logstash behind fabio

### Components
 - Developement consul cluster of 3 dockerized nodes
 - A single dockerized fabio node
 - A developement single node dockerized elasticsearch 
 - A dockerized Kibana 
 - 3 logstash nodes
 - A dockerized filebeat throwing its logs through fabio to logstash 

### Steps

 - create docker network : ./create-network.sh
 - Start consul : ./consul-cluster-start.sh
 - Start fabio : ./fabio-start.sh
 - Start elasticsearch : ./elasticseach-start.sh
 - Start kibana (it can take some time to start) :  ./kibana-start.sh
 - If kibana respond with 403 status codes : 
    - In dev tools run the two following commands :
```
PUT /_cluster/settings
{
"persistent" : {
"cluster.routing.allocation.disk.threshold_enabled" : false
}
}

PUT .kibana/_settings
{
"index": {
"blocks": {
"read_only_allow_delete": false
}
}
}
```
 - Build logstash : docker build -t logstash-consul logstash
 - Start logstash (it can take some time to start) : ./logstash-start.sh
 - Start filebeat : ./filebeat-start.sh
 	- It will bring you in the container once started. Type the following command :
	- ./filebeat -c filebeat.yml &
	- You then can check if filebeat can communicate with logstash (through fabio) by running : tail -f logs/filebeat
        - if everything goes well you should retrieve filebeat logs in elasticsearch and watch them coming from kibana as well.
</details>

## Usefull urls : 
 - Consul UI : http://localhost:8500/ui
 - Fabio UI : http://localhost:9998/routes
 - App behind fabio : http://localhost:9999/cgi-bin/index.py
