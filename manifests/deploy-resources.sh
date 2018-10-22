#!/usr/bin/env bash

#set -x
os=$(uname)

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

# create nfs server if storage is nfsdisk
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
echo "Creating persistent volume..."
# get ip address of nfs service
if [[ "${storage}" == "nfsdisk" ]]; then
  nfs_ip=$(kubectl get service/nfs-server -o yaml | grep clusterIP | awk '{ print $2 }')
  if [[ "${os}" == "Darwin" ]]; then
    sed -i '' "s|server:.*|server: ${nfs_ip}|g" org1/pv-nfsdisk.yaml
    sed -i '' "s|server:.*|server: ${nfs_ip}|g" orgorderer1/pv-nfsdisk.yaml
  else
    sed -i "s|server:.*|server: ${nfs_ip}|g" org1/pv-nfsdisk.yaml
    sed -i "s|server:.*|server: ${nfs_ip}|g" orgorderer1/pv-nfsdisk.yaml
  fi
elif [[ "${storage}" == "filestore" ]]; then
  nfs_ip=$(gcloud beta filestore instances describe shared-storage --project=terraform-fabric --location=us-west1-a --format="value(networks[0].ipAddresses)")
  if [[ "${os}" == "Darwin" ]]; then
    sed -i '' "s|server:.*|server: ${nfs_ip}|g" org1/pv-filestore.yaml
    sed -i '' "s|server:.*|server: ${nfs_ip}|g" orgorderer1/pv-filestore.yaml
  else
    sed -i "s|server:.*|server: ${nfs_ip}|g" org1/pv-filestore.yaml
    sed -i "s|server:.*|server: ${nfs_ip}|g" orgorderer1/pv-filestore.yaml
  fi
fi

# create org1 resources
if [ -f org1/pv-"${storage}".yaml ] && [ -f org1/pvc-"${storage}".yaml ] && [ -f org1/endorsing-"${storage}".yaml ] && [ -f org1/ca-"${storage}".yaml ] && [ -f org1/tools-"${storage}".yaml ]; then
  echo "Creating org1 resources..."
  kubectl create -f org1/pv-"${storage}".yaml --save-config
  if [[ "${os}" == "Darwin" ]]; then
    sed -i '' "s|server:.*|server:|g" org1/pv-nfsdisk.yaml
  else
    sed -i "s|server:.*|server:|g" org1/pv-nfsdisk.yaml
  fi
  kubectl create -f org1/pvc-"${storage}".yaml --save-config
  kubectl create -f org1/endorsing-"${storage}".yaml --save-config
  kubectl create -f org1/ca-"${storage}".yaml --save-config
  kubectl create -f org1/tools-"${storage}".yaml --save-config
  echo ""
  sleep 1
else
  echo "YAML manifest does not exist"
  exit 1
fi

# create orgorderer1 resources
if [ -f orgorderer1/pv-"${storage}".yaml ] && [ -f orgorderer1/pvc-"${storage}".yaml ] && [ -f orgorderer1/ordering-"${storage}".yaml ]; then
  echo "Creating orgorderer1 resources..."
  kubectl create -f orgorderer1/pv-"${storage}".yaml --save-config
  if [[ "${os}" == "Darwin" ]]; then
    sed -i '' "s|server:.*|server:|g" orgorderer1/pv-nfsdisk.yaml
  else
    sed -i "s|server:.*|server:|g" orgorderer1/pv-nfsdisk.yaml
  fi
  kubectl create -f orgorderer1/pvc-"${storage}".yaml --save-config
  kubectl create -f orgorderer1/ordering-"${storage}".yaml --save-config
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
