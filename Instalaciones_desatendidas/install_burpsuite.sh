#!/bin/bash

sudo apt update

sudo apt install -y megatools

mkdir -p $HOME/Escritorio/burpsuite

cd $HOME/Escritorio/burpsuite

java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

if [[ -z "$java_version" ]]; then
	sudo wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
	dpkg -i jdk-21_linux-x64_bin.deb
else
	if [[ "$java_version"=="21"* ]]; then
		:
	else
		sudo wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb
	        dpkg -i jdk-21_linux-x64_bin.deb
	fi
fi

megadl 'https://mega.nz/file/EQ4wnToA#rrUPgqTLszJ1RfN8hmNLsMO-X2fNqv6MXL7tfF0iJU0'

chmod +x burpsuite_community_linux_v2024_5_5.sh

./burpsuite_community_linux_v2024_5_5.sh -q -dir $HOME/Escritorio/burpsuite
