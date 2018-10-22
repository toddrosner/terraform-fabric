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

# delete nfs server
if [[ "${storage}" == "nfsdisk" ]]; then
  kubectl delete deployment nfs-server
  kubectl delete service nfs-server
fi

# delete all resources
kubectl delete deployment --all --namespace org1
kubectl delete service --all --namespace org1
kubectl delete pvc --all --namespace org1

kubectl delete deployment --all --namespace orgorderer1
kubectl delete service --all --namespace orgorderer1
kubectl delete pvc --all --namespace orgorderer1

kubectl delete deployment --all --namespace kafka
kubectl delete service --all --namespace kafka

kubectl delete pv --all

kubectl delete namespace org1 orgorderer1 kafka

# delete any pods stuck in a terminating state
kubectl delete pod --all --namespace org1 --force --grace-period 0
kubectl delete pod --all --namespace orgorderer1 --force --grace-period 0
