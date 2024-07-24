#!/bin/bash

mkdir -p $HOME/Escritorio/Photon

cd $HOME/Escritorio/Photon

git clone https://github.com/s0md3v/Photon.git

pip3 install tld requests --break-system-packages
