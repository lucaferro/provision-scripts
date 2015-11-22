#!/bin/bash

###############
## Definitions
###############

_UBUNTU_USER_BASH=`readlink -e "$0"`

BASE_DIR=`dirname "${_UBUNTU_USER_BASH}"`

INITIAL_DIR="$(pwd)"

####
## prv_download PKG_NAME
##              PKG_VERSION
##              PKG32_FILE
##              PKG32_SHA1
##              PKG32_LINK
##              PKG64_FILE
##              PKG64_SHA1
##              PKG64_LINK
##
## Example:
## prv_download "eclipse-cpp" \
##              "4.4.2-luna" \
##              "eclipse-cpp-luna-SR2-linux-gtk.tar.gz" \
##              "6c13cf209e20c094da3330d84240ce27a7fdff7c" \
##              "http://mirror.ibcp.fr/pub/eclipse//technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk.tar.gz" \
##              "eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz" \
##              "98e404ab5fb3a31e0d5a3aa5e32edec04c1b1880" \
##              "http://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz"
##
function prv_download() {
	[ $# -ne 8 ] && exit 1

	PKG_NAME="$1"
	PKG_VERSION="$2"
	PKG_FILE="$6"
	PKG_SHA1="$7"
	PKG_LINK="$8"
	if [ "${ARCH_32}" == "1" ] ; then
		PKG_FILE="$3"
		PKG_SHA1="$4"
		PKG_LINK="$5"
	fi

	echo "> downloading ${PKG_NAME}-${PKG_VERSION}" && \
		rm -fR /tmp/${PKG_NAME}-${PKG_VERSION} && \
		mkdir -p /tmp/${PKG_NAME}-${PKG_VERSION} && \
		cd /tmp/${PKG_NAME}-${PKG_VERSION} && \
		echo "${PKG_SHA1}  ${PKG_FILE}" > ${PKG_FILE}.sha1 && \
		wget "${PKG_LINK}" && \
		sleep 1s
	[ $? -ne 0 ] && echo "> ERROR" && exit 2

	if [ ${#PKG_SHA1} -eq 32 ] ; then
		md5sum -c ${PKG_FILE}.sha1
	else
		sha1sum -c ${PKG_FILE}.sha1
	fi
	[ $? -ne 0 ] && echo "> ERROR" && exit 2
}

####
## prv_extract PKG_NAME
##             PKG_VERSION
##             PKG32_FILE
##             PKG64_FILE
##
## Example:
## prv_extract "eclipse-cpp" \
##             "4.4.2-luna" \
##             "eclipse-cpp-luna-SR2-linux-gtk.tar.gz" \
##             "eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz"
##
function prv_extract() {
	[ $# -ne 4 ] && exit 1

	PKG_NAME="$1"
	PKG_VERSION="$2"
	PKG_FILE="$4"
	if [ "${ARCH_32}" == "1" ] ; then
		PKG_FILE="$3"
	fi

	echo "> extracting ${PKG_NAME}-${PKG_VERSION}" && \
		cd /tmp/${PKG_NAME}-${PKG_VERSION} && \
		mkdir out
	[ $? -ne 0 ] && echo "> ERROR" && exit 3

	if [[ "${PKG_FILE}" == *.zip ]] ; then
		unzip ${PKG_FILE} -d out
		[ $? -ne 0 ] && echo "> ERROR" && exit 3
	elif [[ "${PKG_FILE}" == *.tar ]] ; then
		tar xf ${PKG_FILE} --directory out
		[ $? -ne 0 ] && echo "> ERROR" && exit 3
	elif [[ "${PKG_FILE}" == *.tgz ]] || [[ "${PKG_FILE}" == *.tar.gz ]] ; then
		tar zxf ${PKG_FILE} --directory out
		[ $? -ne 0 ] && echo "> ERROR" && exit 3
	elif [[ "${PKG_FILE}" == *.tar.bz2 ]] ; then
		tar jxf ${PKG_FILE} --directory out
		[ $? -ne 0 ] && echo "> ERROR" && exit 3
	else
		echo "> ERROR" && exit 3
	fi
}

####
## prv_dump_bashrc PKG_NAME
##                 PKG_VERSION
##                 [ BASHRC_CUSTOM_PRE [ BASHRC_CUSTOM_POST ] ]
##
## It creates a file named PKG_NAME-PKG_VERSION.bashrc (or PKG_NAME only, if
## PKG_VERSION is empty) under the temporary folder /tmp/PKG_NAME-PKG_VERSION
## (still PKG_NAME only, if PKG_VERSION is empty).
##
## Example:
## prv_dump_bashrc "eclipse-cpp" \
##                 "4.4.2-luna" \
##                 'export FOO=1' \
##                 'export BAR=2'
##
function prv_dump_bashrc() {
	if [ $# -lt 2 ] || [ $# -gt 4 ] ; then
		exit 1
	fi

	PKG_NAME="$1"
	PKG_VERSION="$2"
	PKG_NAME_VER="${PKG_NAME}-${PKG_VERSION}"
	[ -z "$PKG_VERSION" ] && PKG_NAME_VER="${PKG_NAME}"
	PKG_ID="$(uuidgen | sed 's/\([a-zA-Z0-9]*\)-.*/\1/' | xargs echo -n)"
	BASHRC_CUSTOM_PRE=""
	[ $# -gt 2 ] && BASHRC_CUSTOM_PRE="$3"
	BASHRC_CUSTOM_POST=""
	[ $# -gt 3 ] && BASHRC_CUSTOM_POST="$4"

	BASHRC_CUSTOM_HOME='export '"${PKG_NAME}"'_HOME=${HOME}/opt/'"${PKG_NAME}"'-${'"${PKG_NAME}"'_VERSION_}'
	[ -z "$PKG_VERSION" ] && BASHRC_CUSTOM_HOME='export '"${PKG_NAME}"'_HOME=${HOME}/opt/'"${PKG_NAME}"''

	echo "> dumping bashrc for ${PKG_NAME_VER}" && \
		mkdir -p /tmp/${PKG_NAME_VER} && \
		cd /tmp/${PKG_NAME_VER} && \
		echo '' > ${PKG_NAME_VER}.bashrc && \
		echo 'if [ -z "${PKG_'"${PKG_ID}"'}" ] || [ "${PKG_'"${PKG_ID}"'}" == "0" ]' >> ${PKG_NAME_VER}.bashrc && \
		echo 'then' >> ${PKG_NAME_VER}.bashrc && \
		echo "${BASHRC_CUSTOM_PRE}" >> ${PKG_NAME_VER}.bashrc && \
		echo 'export '"${PKG_NAME}"'_VERSION_='"${PKG_VERSION}" >> ${PKG_NAME_VER}.bashrc && \
		echo "$BASHRC_CUSTOM_HOME" >> ${PKG_NAME_VER}.bashrc && \
		echo 'export PATH=${PATH}:${'"${PKG_NAME}"'_HOME}/bin' >> ${PKG_NAME_VER}.bashrc && \
		echo "${BASHRC_CUSTOM_POST}" >> ${PKG_NAME_VER}.bashrc && \
		echo 'fi' >> ${PKG_NAME_VER}.bashrc && \
		echo 'export PKG_'"${PKG_ID}"'="1"' >> ${PKG_NAME_VER}.bashrc && \
		echo '' >> ${PKG_NAME_VER}.bashrc
	[ $? -ne 0 ] && echo "> ERROR" && exit 4
}


####
## prv_deploy PKG_NAME PKG_VERSION [ PKG_BASE_DIR ]
##
## Example:
## prv_deploy "eclipse-cpp" "4.4.2-luna" "$HOME/opt"
##
function prv_deploy() {
	if [ $# -lt 2 ] || [ $# -gt 3 ] ; then
		exit 1
	fi

	PKG_NAME="$1"
	PKG_VERSION="$2"
	PKG_BASE_DIR="${HOME}/opt"
	[ $# -gt 2 ] && PKG_BASE_DIR="$3"
	PKG_HOME=${PKG_BASE_DIR}/${PKG_NAME}-${PKG_VERSION}

	echo "> deploying ${PKG_NAME}-${PKG_VERSION}" && \
		cd /tmp/${PKG_NAME}-${PKG_VERSION} && \
		mkdir -p ${PKG_BASE_DIR} && \
		mv out/* ${PKG_HOME}
	[ $? -ne 0 ] && echo "> ERROR" && exit 5
	if [ -f "${PKG_NAME}-${PKG_VERSION}.bashrc" ] ; then
		mv ${PKG_NAME}-${PKG_VERSION}.bashrc ${HOME}/opt && \
			. ${HOME}/opt/${PKG_NAME}-${PKG_VERSION}.bashrc
		[ $? -ne 0 ] && echo "> ERROR" && exit 5
	fi
}

####
## prv_install PKG_NAME
##              PKG_VERSION
##              PKG32_FILE
##              PKG32_SHA1
##              PKG32_LINK
##              PKG64_FILE
##              PKG64_SHA1
##              PKG64_LINK
##              [ BASHRC_CUSTOM_PRE [ BASHRC_CUSTOM_POST ] ]
##
## Example:
## prv_install "eclipse-cpp" \
##              "4.4.2-luna" \
##              "eclipse-cpp-luna-SR2-linux-gtk.tar.gz" \
##              "6c13cf209e20c094da3330d84240ce27a7fdff7c" \
##              "http://mirror.ibcp.fr/pub/eclipse//technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk.tar.gz" \
##              "eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz" \
##              "98e404ab5fb3a31e0d5a3aa5e32edec04c1b1880" \
##              "http://mirror.ibcp.fr/pub/eclipse/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz" \
##              'export FOO=1' \
##              'export BAR=2'
##
function prv_install() {
	if [ $# -lt 8 ] || [ $# -gt 10 ] ; then
		exit 1
	fi

	BASHRC_CUSTOM_PRE=""
	[ $# -gt 8 ] && BASHRC_CUSTOM_PRE="$9"
	BASHRC_CUSTOM_POST=""
	[ $# -gt 9 ] && BASHRC_CUSTOM_POST="$10"

	if [ ! -d "${HOME}/opt/$1-$2" ] ; then
		prv_download "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8"
		prv_extract "$1" "$2" "$3" "$6"
		prv_dump_bashrc "$1" "$2" "$BASHRC_CUSTOM_PRE" "$BASHRC_CUSTOM_POST"
		prv_deploy "$1" "$2"
	fi
}

################
## Initial conf
################

echo "> guessing arch"
uname -m |grep "64"
ARCH_32="$?"
[ "${ARCH_32}" != "0" ] && [ "${ARCH_32}" != "1" ] && echo "> ERROR" && exit 1

echo "> creating ${HOME}/opt"
mkdir -p "${HOME}/opt"
[ $? -ne 0 ] && echo "> ERROR" && exit 1

##################
## Run installers
##################

## First, run all the installers directly under user.d,
## then, run installers from direct subfolders, by considering
## the folders in alphabetical order.
## PLEASE avoid whitespaces and "exotic" characters in folder and
## and file names.

PRV_USERD_TOP_INSTALLERS=$( find "${BASE_DIR}/user.d" -mindepth 1 -maxdepth 1 -type f -name "*.bash" )
PRV_USERD_SUBFOLDERS=$( find "${BASE_DIR}/user.d" -mindepth 1 -maxdepth 1 -type d | sort )

for i in $PRV_USERD_TOP_INSTALLERS ; do
	. ${i}
done

for d in $PRV_USERD_SUBFOLDERS ; do
	for i in `find "$d" -mindepth 1 -maxdepth 1 -type f -name "*.bash"` ; do
		. ${i}
	done
done

cd ${INITIAL_DIR} && echo "> DONE"
