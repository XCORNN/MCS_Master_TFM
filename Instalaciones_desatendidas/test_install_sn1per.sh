#!/bin/bash

# Instalar dependencias
sudo apt install -y git build-essential

# Crear el directorio y clonar el repositorio
mkdir -p /home/$USER/Descargas/sn1per
cd /home/$USER/Descargas/sn1per
git clone https://github.com/1N3/Sn1per.git .

# Instalar Sn1per
sudo bash install.sh

echo "Sn1per ha sido instalado correctamente."

# Ejecutar Sn1per con un ejemplo de dominio
# Puedes reemplazar 'example.com' por el dominio o IP que quieras escanear
sniper -t example.com
