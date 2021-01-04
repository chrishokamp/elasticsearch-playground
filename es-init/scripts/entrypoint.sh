#!/bin/sh


echo Waiting for elasticsearch... 
./scripts/waitfor -t 120  es01:9200

sleep 2

echo Elasticsearch ready to serve requests 

# disable disk threshold
curl --location -XPUT http://es01:9200/_cluster/settings -H "Content-Type: application/json" -d '{"persistent" : {"cluster.routing.allocation.disk.threshold_enabled": false}}'

echo Delete index mapping 
curl --location --request DELETE 'http://es01:9200/nobel'

echo 
echo Create nobel index mapping 
curl --location --request PUT 'http://es01:9200/nobel' --header 'Content-Type: application/json' -d @data/nobel-template.json

echo 
echo import data 
elasticdump --output=http://es01:9200/nobel --input=./data/nobel.json --type=data --transform="doc._source=Object.assign({},doc)"

