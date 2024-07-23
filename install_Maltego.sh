#!/bin/bash

#instalación de Malt
wget https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.7.0.deb

export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

dpkg -i Maltego.v4.7.00.deb

#instalación de Java
apt install -y default-jre

apt install -y default-jdk
