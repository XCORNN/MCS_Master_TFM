#!/bin/bash

if [ which pip3 &>/dev/null ];
then
	pip3 install osrframework --user --break-system-packages
else
	sudo apt update
	sudo apt install -y python3-pip
	pip3 install osrframework --user --break-system-packages
fi

mkdir -p $HOME/Escritorio/osrframework

cp -r ~/.local/bin/* $HOME/Escritorio/osrframework
