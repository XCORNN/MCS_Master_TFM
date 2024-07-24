#!/bin/bash

mkdir -p $HOME/Escritorio/Photon

cd $HOME/Escritorio/Photon

git clone https://github.com/s0md3v/Photon.git

if [ which pip3 &> /dev/null ];
then
	pip3 install tld requests --break-system-packages
else
	apt install -y python3-pip
	pip3 install tld requests --break-system-packages
fi
