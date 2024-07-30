#!/bin/bash

# Verificar si se está ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta el script con sudo."
  exit 1
fi

# Definir el directorio de instalación
INSTALL_DIR="/home/master/Escritorio/inurlbr"
REPO_URL="https://github.com/MrCl0wnLab/SCANNER-INURLBR.git"

# Actualizar los paquetes
echo "Actualizando los paquetes..."
apt-get update -y
apt-get upgrade -y

# Instalar Git y PHP
echo "Instalando Git y PHP..."
apt-get install git php php-cli php-curl -y

# Crear el directorio para SCANNER-INURLBR
echo "Creando el directorio $INSTALL_DIR..."
mkdir -p $INSTALL_DIR

# Cambiar al directorio creado
cd $INSTALL_DIR

# Clonar el repositorio de SCANNER-INURLBR
echo "Clonando el repositorio de SCANNER-INURLBR en $INSTALL_DIR..."
git clone $REPO_URL .

# Mover el contenido del repositorio a la raíz del directorio de instalación
echo "Moviendo el contenido del repositorio..."
mv SCANNER-INURLBR/* .
mv SCANNER-INURLBR/.[!.]* .  # Mover archivos ocultos (como .git)
rmdir SCANNER-INURLBR  # Eliminar la carpeta vacía

# Instalar dependencias de PHP, si existen
echo "Instalando dependencias adicionales para PHP..."
# En este caso, no hay un archivo composer.json ni requisitos adicionales especificados en el repositorio

# Dar permisos de ejecución a los scripts PHP si es necesario
echo "Dando permisos de ejecución a los scripts PHP..."
chmod +x scanner-inurlbr.php

# Cambiar la propiedad del directorio al usuario no root
chown -R master:master $INSTALL_DIR

# Confirmar que la instalación ha finalizado
echo "Instalación completada. Puedes empezar a usar SCANNER-INURLBR desde el directorio '$INSTALL_DIR'."

