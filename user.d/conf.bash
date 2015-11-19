#!/bin/bash

echo "> copying bash_aliases"
if [ ! -f ~/.bash_aliases ] ; then
	cp "${BASE_DIR}/resources/bash_aliases" ~/.bash_aliases
fi
# ubuntu: this file should already be sourced, if it exists

[ $? -ne 0 ] && echo "> ERROR" && exit 1

sleep 1s

echo "> copying bash_functions"
if [ ! -f ~/.bash_functions ] ; then
	cp "${BASE_DIR}/resources/bash_functions" ~/.bash_functions && \
		echo '' >> ~/.bashrc && \
		echo 'if [ -f ~/.bash_functions ]; then' >> ~/.bashrc && \
		echo '    . ~/.bash_functions' >> ~/.bashrc && \
		echo 'fi' >> ~/.bashrc && \
		echo '' >> ~/.bashrc
fi

[ $? -ne 0 ] && echo "> ERROR" && exit 1

sleep 1s

echo "> copying bash_installs"
if [ ! -f ~/.bash_installs ] ; then
	cp "${BASE_DIR}/resources/bash_installs" ~/.bash_installs && \
		echo '' >> ~/.bashrc && \
		echo 'if [ -f ~/.bash_installs ]; then' >> ~/.bashrc && \
		echo '    . ~/.bash_installs' >> ~/.bashrc && \
		echo 'fi' >> ~/.bashrc && \
		echo '' >> ~/.bashrc
fi

[ $? -ne 0 ] && echo "> ERROR" && exit 1

sleep 1s

echo "> copying gitconfig"
if [ ! -f ~/.gitconfig ] ; then
	cp "${BASE_DIR}/resources/gitconfig" ~/.gitconfig
fi

[ $? -ne 0 ] && echo "> ERROR" && exit 1

sleep 1s
