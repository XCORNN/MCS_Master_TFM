#!/bin/bash

mkdir -p $HOME/Escritorio/sherlock

cd $HOME/Escritorio/sherlock

if [ which pip3 &>/dev/null ];
then
	sudo pip3 install sherlock-project --break-system-packages
else
	sudo apt install -y python3-pip
	sudo pip3 install sherlock-project --break-system-packages
fi
