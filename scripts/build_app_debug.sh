#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PRJ_DIR=$SCRIPT_DIR/..
mkdir -p $PRJ_DIR/bin
# select the right build command for your platform
# GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -gcflags=all='-N -l' -o $PRJ_DIR/bin/main $PRJ_DIR/cmd/main/main.go
GOOS=linux GOARCH=arm64 CGO_ENABLED=0 go build -gcflags=all='-N -l' -o $PRJ_DIR/bin/main $PRJ_DIR/cmd/main/main.go