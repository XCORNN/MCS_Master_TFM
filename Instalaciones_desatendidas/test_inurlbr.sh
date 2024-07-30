#!/bin/bash

# Verificar si se está ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta el script con sudo."
  exit 1
fi

# Actualizar los paquetes
echo "Actualizando los paquetes..."
sudo apt-get update -y

# Instalar Git
echo "Instalando Git..."
sudo apt-get install git -y

# Crear la ruta /home/$USER/Escritorio/inurlbr
echo "Creando la ruta /home/master/Escritorio/inurlbr..."
mkdir -p /home/master/Escritorio/inurlbr

# Cambiar al directorio creado
cd /home/master/Escritorio/inurlbr

# Clonar el repositorio en la nueva ruta
echo "Clonando el repositorio de INURLBR en /home/$USER/Escritorio/inurlbr..."
git clone https://github.com/MrCl0wnLab/SCANNER-INURLBR.git

# Instalar dependencias adicionales si las hubiera (ejemplo: curl, php)
echo "Instalando dependencias adicionales..."
apt-get install curl libcurl4 libcurl4-openssl-dev php php-cli php-curl -y

#Mover a carpeta interna:
cd /home/master/Escritorio/inurlbr/SCANNER-INURLBR

# Dar permisos de ejecución a los scripts
echo "Dando permisos de ejecución a los scripts..."
chmod +x inurlbr.php

# Confirmar que la instalación ha finalizado
echo "Instalación completada. Puedes empezar a usar INURLBR desde el directorio '/home/master/Escritorio/inurlbr'."
