#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Define el directorio de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/TheHarvester"

# Crea el directorio de destino si no existe
depriv bash -c "
if [ ! -d '$DEST_DIR' ]; then
    echo 'Creando el directorio $DEST_DIR...'
    mkdir -p '$DEST_DIR'
    if [ \$? -ne 0 ]; then
        echo 'Error al crear el directorio $DEST_DIR. Verifica los permisos.'
        exit 1
    fi
else
    echo 'El directorio $DEST_DIR ya existe.'
fi
"

# Navega al directorio de destino
cd "$DEST_DIR" || { echo "No se pudo cambiar al directorio $DEST_DIR."; exit 1; }

# Clonar el repositorio de theHarvester
depriv git clone https://github.com/laramies/theHarvester.git

# Entrar en el directorio de theHarvester
cd theHarvester || { echo "No se pudo cambiar al directorio theHarvester."; exit 1; }

# Crear y activar un entorno virtual para Python
depriv bash -c "
python3 -m venv venv
source venv/bin/activate
"

# Instalar las dependencias de theHarvester dentro del entorno virtual
depriv bash -c "
source venv/bin/activate
pip install -r requirements/base.txt
"

echo "Instalación completa de theHarvester"
