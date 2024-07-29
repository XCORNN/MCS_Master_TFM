#!/bin/bash

sudo apt update

if [ which go &>/dev/null ];
then
	go version
else
	sudo apt install -y golang-go
fi

if [ which python3 &>/dev/null ];
then
        python3 --version
else
        sudo apt install -y python3 python3-pip
fi

mkdir -p $HOME/Mosint
cd $HOME/Mosint

git clone https://github.com/alpeskin/mosint

cd mosint/v3/cmd/mosint

go run main.go -h &>/dev/null

