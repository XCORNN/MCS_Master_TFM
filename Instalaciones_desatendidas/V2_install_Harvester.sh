#!/bin/bash

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

mkdir -p $HOME/Escritorio/TheHarvester

cd $HOME/Escritorio/TheHarvester

# Clonar el repositorio de theHarvester
git clone https://github.com/laramies/theHarvester.git

# Entrar en el directorio de theHarvester
cd theHarvester

# Instalar las dependencias de theHarvester
if [ which pip3 &>/dev/null ];
then
	sudo pip3 install -r requirements/base.txt --break-system-packages
else
	sudo apt install -y python3-pip
	sudo pip3 install -r requirements/base.txt --break-system-packages
fi
