#!/bin/bash

INITIAL_DIR="`pwd`"

echo "> going sudo" && sudo true

[ $? -ne 0 ] && echo "> ERROR" && exit 1

echo "> apt-get update" && \
	sleep 1s && \
	sudo apt-get update

[ $? -ne 0 ] && echo "> ERROR" && exit 2

echo "> apt-get install some packages..." && \
	sleep 1s && \
	sudo apt-get -y install \
		make \
		gcc \
		g++ \
		clang-format-3.4 \
		git \
		mercurial \
		default-jre \
		default-jdk \
		htop \
		geany \
		xclip \
		meld \
		python \
		python-setuptools \
		fakeroot \
		fakechroot

[ $? -ne 0 ] && echo "> ERROR" && exit 3

sleep 1s

cd ${INITIAL_DIR} && echo "> DONE"
