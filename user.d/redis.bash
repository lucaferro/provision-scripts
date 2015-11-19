#!/bin/bash

function redis_install() {
	[ $# -ne 8 ] && exit 1
	if [ ! -d "${HOME}/opt/$1-$2" ] ; then
		prv_download "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		prv_extract "$1" "$2" "$3" "$6"

		#cd out/*
		echo "> building $1-$2" && \
			cd /tmp/"$1"-"$2"/out/"$1"-"$2" && \
			make && \
			sleep 1s && \
			make test
		[ $? -ne 0 ] && echo "> ERROR" && exit 6

		prv_dump_bashrc "$1" "$2"

		#prv_deploy "$1" "$2"
		echo "> deploying $1-$2" && \
			cd /tmp/$1-$2 && \
			mkdir -p ${HOME}/opt/$1-$2/bin && \
			cp out/$1-$2/src/redis-{cli,server} ${HOME}/opt/$1-$2/bin && \
			cp out/$1-$2/redis.conf ${HOME}/opt/$1-$2 && \
			cp $1-$2.bashrc ${HOME}/opt
		[ $? -ne 0 ] && echo "> ERROR" && exit 5

	fi
}

##
## tests are failing for:
##
#redis_install 'redis' '3.0.4' \
#	'redis-3.0.4.tar.gz' \
#	'cccc58b2b8643930840870f17280fcae57ed7675' \
#	'http://download.redis.io/releases/redis-3.0.4.tar.gz' \
#	'redis-3.0.4.tar.gz' \
#	'cccc58b2b8643930840870f17280fcae57ed7675' \
#	'http://download.redis.io/releases/redis-3.0.4.tar.gz'

##
## tests are failing for:
##
#redis_install 'redis' '2.8.22' \
	#'redis-2.8.22.tar.gz' \
	#'78a70b32cdd3a4ccc58880d1821fb828d091bb36' \
	#'http://download.redis.io/releases/redis-2.8.22.tar.gz' \
	#'redis-2.8.22.tar.gz' \
	#'78a70b32cdd3a4ccc58880d1821fb828d091bb36' \
	#'http://download.redis.io/releases/redis-2.8.22.tar.gz'

redis_install 'redis' '2.6.17' \
	'redis-2.6.17.tar.gz' \
	'b5423e1c423d502074cbd0b21bd4e820409d2003' \
	'http://download.redis.io/releases/redis-2.6.17.tar.gz' \
	'redis-2.6.17.tar.gz' \
	'b5423e1c423d502074cbd0b21bd4e820409d2003' \
	'http://download.redis.io/releases/redis-2.6.17.tar.gz'

sleep 1s
