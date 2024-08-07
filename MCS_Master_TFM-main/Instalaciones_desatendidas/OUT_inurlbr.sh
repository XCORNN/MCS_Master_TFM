#!/bin/bash

# Verificar si se está ejecutando con sudo
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta el script con sudo."
  exit 1
fi

# Definir el directorio de instalación y URL del repositorio
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

# Verificar el nombre de la carpeta clonada
CLONED_DIR=$(ls -d */ | head -n 1 | sed 's#/##')

# Comprobar si la carpeta clonada existe
if [ -z "$CLONED_DIR" ]; then
  echo "No se encontró ninguna carpeta clonada."
  exit 1
fi

# Mover el contenido del repositorio a la raíz del directorio de instalación
echo "Moviendo el contenido del repositorio desde '$CLONED_DIR'..."
mv "$CLONED_DIR"/* . || { echo "Error moviendo archivos."; exit 1; }
mv "$CLONED_DIR"/.[!.]* . || { echo "Error moviendo archivos ocultos."; exit 1; }

# Eliminar la carpeta clonada
echo "Eliminando la carpeta vacía '$CLONED_DIR'..."
rmdir "$CLONED_DIR" || { echo "Error eliminando la carpeta '$CLONED_DIR'."; exit 1; }

# Instalar dependencias de PHP, si existen
echo "Instalando dependencias adicionales para PHP..."
# En este caso, no hay un archivo composer.json ni requisitos adicionales especificados en el repositorio

# Dar permisos de ejecución a los scripts PHP si es necesario
echo "Dando permisos de ejecución a los scripts PHP..."
chmod +x scanner-inurlbr.php || { echo "Error al dar permisos de ejecución."; exit 1; }

# Cambiar la propiedad del directorio al usuario no root
chown -R master:master $INSTALL_DIR

# Confirmar que la instalación ha finalizado
echo "Instalación completada. Puedes empezar a usar SCANNER-INURLBR desde el directorio '$INSTALL_DIR'."
