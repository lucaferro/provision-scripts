#!/bin/bash

INITIAL_DIR="`pwd`"

echo "> go getting github.com/nsf/gocode" && \
	mkdir -p ${HOME}/workspace/gorepos && \
	cd ${HOME}/workspace/gorepos && \
	GOPATH=${HOME}/workspace/gorepos go get -u github.com/nsf/gocode

[ $? -ne 0 ] && echo "> ERROR" && exit 1

sleep 1s

echo "> go getting golang.org/x/tools/cmd/oracle" && \
	mkdir -p ${HOME}/workspace/gorepos && \
	cd ${HOME}/workspace/gorepos && \
	GOPATH=${HOME}/workspace/gorepos go get -u golang.org/x/tools/cmd/oracle

[ $? -ne 0 ] && echo "> ERROR" && exit 1

sleep 1s

cd ${INITIAL_DIR} && echo "> DONE"
