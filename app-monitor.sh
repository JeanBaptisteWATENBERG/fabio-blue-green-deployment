#!/bin/sh
while :
do
  status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9999/cgi-bin/index.py)
  if [ $status -gt 201 ]
  then
     notify-send $status
  fi
done
