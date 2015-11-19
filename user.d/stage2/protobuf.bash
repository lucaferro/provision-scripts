#!/bin/bash

function protobuf_install() {
	[ $# -ne 8 ] && echo "> ERROR" && exit 1
	if [ ! -d "${HOME}/opt/$1-$2" ] ; then
		_PRV_MAVENS=$( ls ${HOME}/opt/maven-*.bashrc )
		[ `ls -l $_PRV_MAVENS | wc -l` -ne 1 ] && echo "> ERROR" && exit 6
		. "${_PRV_MAVENS}"
		[ $? -ne 0 ] && echo "> ERROR" && exit 7

		prv_download "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		prv_extract "$1" "$2" "$3" "$6"

		echo "> building $1-$2" && \
			cd "/tmp/$1-$2/out/$1-$2" && \
			./configure --prefix="${HOME}/opt/$1-$2" && \
			sleep 1s && \
			make && \
			sleep 1s && \
			make install
		[ $? -ne 0 ] && echo "> ERROR" && exit 2

		prv_dump_bashrc "$1" "$2"
		mv "/tmp/$1-$2/$1-$2.bashrc" "${HOME}/opt" && \
			. "${HOME}/opt/$1-$2.bashrc"
		[ $? -ne 0 ] && echo "> ERROR" && exit 3

		echo "> building $1-$2 java" && \
			cd "/tmp/$1-$2/out/$1-$2/java" && \
			protoc --version && \
			mvn --version && \
			/bin/cp -f "`which protoc`" "/tmp/$1-$2/out/$1-$2/src" && \
			mvn package && \
			sleep 1s && \
			mkdir -p "${HOME}/opt/$1-$2/lib/java" && \
			cp target/*.jar "${HOME}/opt/$1-$2/lib/java"
		[ $? -ne 0 ] && echo "> ERROR" && exit 4

		echo "> building $1-$2 python" && \
			cd "/tmp/$1-$2/out/$1-$2/python" && \
			python --version && \
			protoc --version && \
			/bin/cp -f "`which protoc`" "/tmp/$1-$2/out/$1-$2/src" && \
			python setup.py build && \
			sleep 1s && \
			python setup.py google_test && \
			sleep 1s && \
			mkdir -p ${HOME}/opt/$1-$2/lib/python2.7/site-packages && \
			export PYTHONPATH=$PYTHONPATH:${HOME}/opt/$1-$2/lib/python2.7/site-packages && \
			python setup.py install --prefix=${HOME}/opt/$1-$2 && \
			sleep 1s
		[ $? -ne 0 ] && echo "> ERROR" && exit 5

		#export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
		#export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=2
	fi
}

protobuf_install 'protobuf' '2.6.1' \
	'protobuf-2.6.1.tar.gz' \
	'f3916ce13b7fcb3072a1fa8cf02b2423' \
	'https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz' \
	'protobuf-2.6.1.tar.gz' \
	'f3916ce13b7fcb3072a1fa8cf02b2423' \
	'https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz'

sleep 1s
