#!/bin/bash

# Actualizar el sistema
sudo apt update

# Instalar dependencias necesarias
sudo apt install -y git python3 python3-pip

# Clonar el repositorio de Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git

# Cambiar al directorio de Sublist3r
cd Sublist3r

# Instalar las dependencias de Python
pip3 install -r requirements.txt

# Confirmación de instalación
echo "Sublist3r ha sido instalado correctamente"
