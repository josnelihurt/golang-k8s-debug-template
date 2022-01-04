#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PRJ_DIR=$SCRIPT_DIR/..
cd $PRJ_DIR
deployment_name="golang-k8s-debug"

eval $(minikube docker-env)
docker build -t local/$deployment_name -f $PRJ_DIR/Dockerfile.debug $PRJ_DIR