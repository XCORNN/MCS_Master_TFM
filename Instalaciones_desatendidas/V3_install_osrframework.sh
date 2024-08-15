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
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script debe ejecutarse como root"
    exit 1
fi

# Definir la ruta del entorno virtual
DEST_DIR="/home/$SUDO_USER/Escritorio/osrframework-venv"

# Instalar paquetes necesarios
depriv bash -c "sudo apt update && sudo apt install -y python3 python3-pip python3-venv"

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

# Navega al directorio de destino y configura el entorno virtual
depriv bash -c "
cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }

# Crea un entorno virtual para Python
python3 -m venv venv

# Verifica que el entorno virtual se ha creado correctamente
if [ ! -f 'venv/bin/activate' ]; then
    echo 'Error: No se pudo crear el entorno virtual. Verifica la instalación de python3-venv.'
    exit 1
fi

# Instala los paquetes necesarios
venv/bin/pip install osrframework
venv/bin/pip install urllib3==1.26.15
venv/bin/pip install --upgrade cfscrape
venv/bin/pip install --upgrade osrframework
"

echo "Instalación completada."
