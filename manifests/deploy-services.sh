#!/usr/bin/env bash

kubectl create -f endorsing.yaml --save-config
kubectl create -f ordering.yaml --save-config
kubectl create -f kafka.yaml --save-config
