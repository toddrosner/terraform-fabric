#!/usr/bin/env bash

#set -x

function usage()
{
  echo "$0 -s <storage>"
  exit
}

while getopts "s:" opt; do
  case $opt in
    s)
      storage="${OPTARG}"
      ;;
    ?)
      usage
      ;;
  esac
done

if [[ -z "${storage}" ]]; then
  echo "Missing a required parameter (storage being either nfsdisk or filestore)"
  usage
fi

if [[ "${storage}" != "nfsdisk" ]] && [[ "${storage}" != "filestore" ]]; then
  echo "Required parameter is incorrect (storage being either nfsdisk or filestore)"
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
if [[ "${storage}" == "nfsdisk" ]]; then
  if [ -f nfsdisk.yaml ]; then
    echo "Creating NFS server..."
    kubectl create -f nfsdisk.yaml --save-config
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
fi

# create persistent volume to nfs server
if [[ "${storage}" == "nfsdisk" ]]; then
  if [ -f pv-nfsdisk.yaml ]; then
    echo "Creating persistent volume..."
    # get cluster ip address of nfs server service
    os=$(uname)
    cluster_ip=$(kubectl get service/nfs-server -o yaml | grep clusterIP | awk '{print $2}')
    if [[ "${os}" == "Darwin" ]]; then
      sed -i '' "s|server:|server: ${cluster_ip}|g" pv-nfsdisk.yaml
      kubectl create -f pv-nfsdisk.yaml --save-config
      sed -i '' "s|server: ${cluster_ip}|server:|g" pv-nfsdisk.yaml
    else
      sed -i "s|server:|server: ${cluster_ip}|g" pv-nfsdisk.yaml
      kubectl create -f pv-nfsdisk.yaml --save-config
      sed -i "s|server: ${cluster_ip}|server:|g" pv-nfsdisk.yaml
    fi
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
elif [[ "${storage}" == "filestore" ]]; then
  if [ -f pv-filestore.yaml ]; then
    echo "Creating persistent volume..."
    # get ip address of filestore instance
    os=$(uname)
    instance_ip=$(gcloud beta filestore instances describe shared-storage --project=terraform-fabric --location=us-west1-a --format='value(networks[0].ipAddresses)')
    if [[ "${os}" == "Darwin" ]]; then
      sed -i '' "s|server:|server: ${instance_ip}|g" pv-filestore.yaml
      kubectl create -f pv-filestore.yaml --save-config
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
if [[ "${storage}" == "nfsdisk" ]]; then
  if [ -f org1/pvc-nfsdisk.yaml ] && [ -f org1/endorsing-nfsdisk.yaml ] && [ -f org1/ca-nfsdisk.yaml ] && [ -f org1/tools-nfsdisk.yaml ]; then
    echo "Creating org1 resources..."
    kubectl create -f org1/pvc-nfsdisk.yaml --save-config
    kubectl create -f org1/endorsing-nfsdisk.yaml --save-config
    kubectl create -f org1/ca-nfsdisk.yaml --save-config
    kubectl create -f org1/tools-nfsdisk.yaml --save-config
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
elif [[ "${storage}" == "filestore" ]]; then
  if [ -f org1/pvc-filestore.yaml ] && [ -f org1/endorsing-filestore.yaml ] && [ -f org1/ca-filestore.yaml ] && [ -f org1/tools-filestore.yaml ]; then
    echo "Creating org1 resources..."
    kubectl create -f org1/pvc-filestore.yaml --save-config
    kubectl create -f org1/endorsing-filestore.yaml --save-config
    kubectl create -f org1/ca-filestore.yaml --save-config
    kubectl create -f org1/tools-filestore.yaml --save-config
    echo ""
    sleep 1
  else
    echo "YAML manifest does not exist"
    exit 1
  fi
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
