#!/usr/bin/env bash

kubectl create -f org1/namespace.yaml --save-config
kubectl create -f org1/endorsing.yaml --save-config
kubectl create -f org1/ordering.yaml --save-config
kubectl create -f org1/kafka.yaml --save-config
