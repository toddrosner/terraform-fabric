#!/usr/bin/env bash

#set -x

function usage()
{
  echo "$0 -n <nfstype>"
  exit
}

while getopts "n:" opt; do
  case $opt in
    n)
      nfstype="${OPTARG}"
      ;;
    ?)
      usage
      ;;
  esac
done

if [[ -z "${nfstype}" ]]; then
  echo "Missing a required parameter (nfstype being either nfsdisk or filestore)"
  usage
fi

if [[ "${nfstype}" != "nfsdisk" ]] && [[ "${nfstype}" != "filestore" ]]; then
  echo "Required parameter is incorrect (nfstype being either nfsdisk or filestore)"
  usage
fi

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

# create nfs server based on argument
if [[ "${nfstype}" == "nfsdisk" ]]; then
  if [ -f nfs-server-disk.yaml ]; then
    echo "Creating NFS server..."
    kubectl create -f nfs-server-disk.yaml --save-config
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
fi

# create persistent volume to nfs server
if [[ "${nfstype}" == "nfsdisk" ]]; then
  if [ -f pv-disk.yaml ]; then
    echo "Creating persistent volume..."
    # get cluster ip address of nfs server service
    os=$(uname)
    cluster_ip=$(kubectl get service/nfs-server -o yaml | grep clusterIP | awk '{print $2}')
    if [[ "${os}" == "Darwin" ]]; then
      sed -i '' "s|server:|server: ${cluster_ip}|g" pv-disk.yaml
      kubectl create -f pv-disk.yaml --save-config
      sed -i '' "s|server: ${cluster_ip}|server:|g" pv-disk.yaml
    else
      sed -i "s|server:|server: ${cluster_ip}|g" pv-disk.yaml
      kubectl create -f pv-disk.yaml --save-config
      sed -i "s|server: ${cluster_ip}|server:|g" pv-disk.yaml
    fi
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
elif [[ "${nfstype}" == "filestore" ]]; then
  if [ -f pv-filestore.yaml ]; then
    echo "Creating persistent volume..."
    # get ip address of filestore instance
    os=$(uname)
    instance_ip=$(gcloud beta filestore instances describe shared-storage --project=terraform-fabric --location=us-west1-a --format='value(networks[0].ipAddresses)')
    if [[ "${os}" == "Darwin" ]]; then
      sed -i '' "s|server:|server: ${instance_ip}|g" pv-filestore.yaml
      kubectl create -f pv-disk.yaml --save-config
      sed -i '' "s|server: ${instance_ip}|server:|g" pv-filestore.yaml
    else
      sed -i "s|server:|server: ${instance_ip}|g" pv-filestore.yaml
      kubectl create -f pv-filestore.yaml --save-config
      sed -i "s|server: ${instance_ip}|server:|g" pv-filestore.yaml
    fi
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
fi

# create org1 resources
if [ -f org1/pvc-disk.yaml ] && [ -f org1/endorsing-disk.yaml ] && [ -f org1/ca.yaml ] && [ -f org1/tools.yaml ]; then
  echo "Creating org1 resources..."
  kubectl create -f org1/pvc-disk.yaml --save-config
  kubectl create -f org1/endorsing-disk.yaml --save-config
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
if [ -f kafka/kafka.yaml ]; then
  echo "Creating Kafka resources..."
  kubectl create -f kafka/kafka.yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi
