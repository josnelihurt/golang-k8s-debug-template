#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

deployment_name="golang-k8s-debug"
namespace_name="local-test"
helm uninstall -n $namespace_name $deployment_name
helm install $deployment_name -n $namespace_name --timeout 60m $SCRIPT_DIR/helm/golang-k8s-debug
sleep 1
pod_count=0
pod_name=`kubectl -n $namespace_name get pods -o wide | grep $deployment_name | grep Running`
while [ -z "$pod_name" ]
do
    echo "plz wait, pod is starting" 
    kubectl -n $namespace_name get pods -o wide | grep $deployment_name
    sleep 1
    pod_name=`kubectl -n $namespace_name get pods -o wide | grep $deployment_name | grep Running`
done
pod_name=`kubectl -n $namespace_name get pods -o wide  | grep $deployment_name | grep Running | cut -f1 -d" "`

echo "pod is now running with pod name -> $pod_name"
kubectl -n $namespace_name port-forward $pod_name 2345:2345