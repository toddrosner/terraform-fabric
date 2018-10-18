#!/usr/bin/env bash

#set -x

# create namespaces
if [ -f namespace.yaml ]; then
  echo "Creating namespaces..."
  kubectl create -f namespace.yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi

# create nfs server
if [ -f nfs-server.yaml ]; then
  echo "Creating NFS server..."
  kubectl create -f nfs-server.yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi

# create persistent volume to nfs server
if [ -f pv.yaml ]; then
  echo "Creating persistent volume..."
  # get cluster ip address of nfs server service
  os=$(uname)
  cluster_ip=$(kubectl get service/nfs-server -o yaml | grep clusterIP | awk '{print $2}')
  if [[ "${os}" == "Darwin" ]]; then
    sed -i '' "s|server:|server: ${cluster_ip}|g" pv.yaml
    kubectl create -f pv.yaml --save-config
    sed -i '' "s|server: ${cluster_ip}|server:|g" pv.yaml
  else
    sed -i "s|server:|server: ${cluster_ip}|g" pv.yaml
    kubectl create -f pv.yaml --save-config
    sed -i "s|server: ${cluster_ip}|server:|g" pv.yaml
  fi
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi

# create org1 resources
if [ -f org1/pvc.yaml ] && [ -f org1/endorsing.yaml ] && [ -f org1/ca.yaml ] && [ -f org1/tools.yaml ]; then
  echo "Creating org1 resources..."
  kubectl create -f org1/pvc.yaml --save-config
  kubectl create -f org1/endorsing.yaml --save-config
  kubectl create -f org1/ca.yaml --save-config
  kubectl create -f org1/tools.yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi

# create org1-orderer resources
if [ -f org1-orderer/ordering.yaml ]; then
  echo "Creating org1-orderer resources..."
  kubectl create -f org1-orderer/ordering.yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi

# create kafka resources
if [ -f kafka.yaml ]; then
  echo "Creating Kafka resources..."
  kubectl create -f kafka.yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi
