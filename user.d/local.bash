#!/bin/bash

echo "> creating ${HOME}/opt/local"
mkdir -p "${HOME}/opt/local/bin"
[ $? -ne 0 ] && echo "> ERROR" && exit 9

prv_dump_bashrc 'local' ''

mv /tmp/local/local.bashrc "${HOME}/opt/" &&
	. "${HOME}/opt/local.bashrc"
[ $? -ne 0 ] && echo "> ERROR" && exit 9

sleep 1s
