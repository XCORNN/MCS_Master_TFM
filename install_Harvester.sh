#!/bin/bash

# Instalar dependencias necesarias
sudo apt install -y python3-pip

# Clonar el repositorio de theHarvester
git clone https://github.com/laramies/theHarvester.git

# Entrar en el directorio de theHarvester
cd theHarvester

# Instalar las dependencias de theHarvester
sudo pip3 install -r requirements/base.txt
