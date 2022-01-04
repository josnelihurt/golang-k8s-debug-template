#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# create the namespace
kubectl create -f $SCRIPT_DIR/namespaces/local-test-namespace.yaml 
exit 0
