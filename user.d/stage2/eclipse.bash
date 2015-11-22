#!/bin/bash

## Eclipse Mars.1 (4.5.1)

function eclipse_install() {
	[ $# -ne 8 ] && exit 1
	if [ ! -d "${HOME}/opt/$1-$2" ] ; then
		prv_download "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		prv_extract "$1" "$2" "$3" "$6"
		prv_deploy "$1" "$2"
		## exe link
		echo "> creating link for ${1}-${2}" && \
			ln -s "${HOME}/opt/${1}-${2}/eclipse" "${HOME}/opt/local/bin/${1}-${2}"
	fi
}


eclipse_install 'eclipse_cpp' '4.5.1' \
	'eclipse-cpp-mars-1-linux-gtk.tar.gz' \
	'4a787c9631a418c08c6418c205e2d55e06786b34' \
	'http://mirror.ibcp.fr/pub/eclipse//technology/epp/downloads/release/mars/1/eclipse-cpp-mars-1-linux-gtk.tar.gz' \
	'eclipse-cpp-mars-1-linux-gtk-x86_64.tar.gz' \
	'acb089bac953232ac1004fee4d7f3b7b84aad68f' \
	'http://mirror.ibcp.fr/pub/eclipse//technology/epp/downloads/release/mars/1/eclipse-cpp-mars-1-linux-gtk-x86_64.tar.gz'

sleep 1s
