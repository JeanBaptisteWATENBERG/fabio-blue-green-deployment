# Fabio - Blue Green deployment

This repository is an attempt to reproduce real world issue in a local simple environment.

The goal is to identify why we get 502 status code when redeploying a docker stack behind fabio.

It holds a simple developpement consul cluster, one fabio node and a simple python application.

Steps :

 - create docker network : ./create-network.sh
 - Start consul : ./consul-cluster-start.sh
 - Start fabio : ./fabio-start.sh
 - build python demo app : docker build -t python-app demo-app
 - Run the app : ./app-start.sh

Useful url : 
 - Consul UI : http://localhost:8500/ui
 - Fabio UI : http://localhost:9998/routes
 - App behind fabio : http://localhost:9999/cgi-bin/index.py
