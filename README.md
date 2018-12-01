# Fabio - Playground

This branch contains an experiment to deploy logstash behind fabio.

Components :
 - Developement consul cluster of 3 dockerized nodes
 - A single dockerized fabio node
 - A developement single node dockerized elasticsearch 
 - A dockerized Kibana 
 - 3 logstash nodes
 - A dockerized filebeat throwing its logs through fabio to logstash 

Steps :

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

Useful url : 
 - Consul UI : http://localhost:8500/ui
 - Fabio UI : http://localhost:9998/routes
 - App behind fabio : http://localhost:9999/cgi-bin/index.py
