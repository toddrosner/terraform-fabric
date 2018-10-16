#!/usr/bin/env bash

# create namespaces
kubectl create -f namespace.yaml --save-config

# create endorsing for org1
kubectl create -f org1/endorsing.yaml --save-config
kubectl create -f org1/ca.yaml --save-config
kubectl create -f org1/tools.yaml --save-config

# create ordering for org1-orderer
kubectl create -f org1-orderer/ordering.yaml --save-config

# create kafka zookeeper
kubectl create -f kafka.yaml --save-config
