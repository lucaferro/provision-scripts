#!/bin/bash

function golang_install() {
	[ $# -ne 9 ] && exit 1
	if [ ! -d "${HOME}/opt/$1-$2" ] ; then
		prv_download "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		prv_extract "$1" "$2" "$3" "$6"
		prv_dump_bashrc "$1" "$2" "" "$9"
		prv_deploy "$1" "$2"
		mkdir -p "${HOME}/workspace/gorepos"
	fi
}

#golang_install 'go' '1.4.2' \
	#'go1.4.2.linux-386.tar.gz' \
	#'50557248e89b6e38d395fda93b2f96b2b860a26a' \
	#'https://storage.googleapis.com/golang/go1.4.2.linux-386.tar.gz' \
	#'go1.4.2.linux-amd64.tar.gz' \
	#'5020af94b52b65cc9b6f11d50a67e4bae07b0aff' \
	#'https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz' \
	#'export GOROOT=${go_HOME} ; export GOPATH=${HOME}/workspace/gorepos'

golang_install 'go' '1.5.1' \
	'go1.5.1.linux-386.tar.gz' \
	'6ce7328f84a863f341876658538dfdf10aff86ee' \
	'https://storage.googleapis.com/golang/go1.5.1.linux-386.tar.gz' \
	'go1.5.1.linux-amd64.tar.gz' \
	'46eecd290d8803887dec718c691cc243f2175fe0' \
	'https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz' \
	'export GOROOT=${go_HOME} ; export GOPATH=${HOME}/workspace/gorepos'

sleep 1s
