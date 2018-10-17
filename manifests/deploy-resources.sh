#!/usr/bin/env bash

# create namespaces
if [ -f namespace.yaml ]; then
  kubectl create -f namespace.yaml --save-config
fi

# create nfs server
if [ -f nfs-server.yaml ]; then
  kubectl create -f nfs-server.yaml --save-config
fi

# persistent volume
if [ -f pv.yaml ]; then
  kubectl create -f pv.yaml --save-config
fi

# create endorsing for org1
if [ -f org1/pvc.yaml ] && [ -f org1/endorsing.yaml ] && [ -f org1/ca.yaml ] && [ -f org1/tools.yaml ]; then
  kubectl create -f org1/pvc.yaml --save-config
  kubectl create -f org1/endorsing.yaml --save-config
  kubectl create -f org1/ca.yaml --save-config
  kubectl create -f org1/tools.yaml --save-config
fi

# create ordering for org1-orderer
if [ -f org1-orderer/ordering.yaml ]; then
  kubectl create -f org1-orderer/ordering.yaml --save-config
fi

# create kafka & zookeeper
if [ -f kafka.yaml ]; then
  kubectl create -f kafka.yaml --save-config
fi
