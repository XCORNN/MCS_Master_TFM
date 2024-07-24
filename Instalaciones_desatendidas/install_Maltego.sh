
#!/bin/bash

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

#instalación de Malt

mkdir -p $HOME/Escritorio/Maltego

cd $HOME/Escritorio/Maltego

wget https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.7.0.deb

export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

dpkg -i $HOME/Escritorio/Maltego/Maltego.v4.7.0.deb

#instalación de Java
apt install -y default-jre

apt install -y default-jdk
