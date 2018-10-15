#!/usr/bin/env bash

# create namespaces
kubectl create -f namespace.yaml --save-config

# create endorsing and ordering for org1
kubectl create -f org1/endorsing.yaml --save-config
kubectl create -f org1/ordering.yaml --save-config

# create kafka zookeeper
kubectl create -f kafka.yaml --save-config
