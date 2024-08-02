#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verifica si el usuario tiene permisos de sudo
if ! sudo -v; then
    echo "El usuario no tiene permisos de sudo. Por favor, asegúrate de tener permisos para instalar paquetes."
    exit 1
fi

# Define el directorio de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/TheHarvester"

# Crea el directorio de destino si no existe
depriv bash -c "
if [ ! -d '$DEST_DIR' ]; then
    echo 'Creando el directorio $DEST_DIR...'
    mkdir -p '$DEST_DIR'
    if [ $? -ne 0 ]; then
        echo 'Error al crear el directorio $DEST_DIR. Verifica los permisos.'
        exit 1
    fi
else
    echo 'El directorio $DEST_DIR ya existe.'
fi
"

# Cambia al directorio de destino
depriv bash -c "
cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }
"

# Clona el repositorio de theHarvester si no está clonado
depriv bash -c "
if [ ! -d '$DEST_DIR/theHarvester/.git' ]; then
    echo 'Clonando el repositorio de theHarvester en $DEST_DIR...'
    git clone https://github.com/laramies/theHarvester.git '$DEST_DIR/theHarvester'
    if [ $? -ne 0 ]; then
        echo 'Error al clonar el repositorio. Verifica la conexión a Internet y los permisos.'
        exit 1
    fi
else
    echo 'El repositorio de theHarvester ya está clonado en $DEST_DIR.'
fi
"

# Instala las dependencias de theHarvester
depriv bash -c "
cd '$DEST_DIR/theHarvester' || { echo 'No se pudo cambiar al directorio de theHarvester.'; exit 1; }
if command -v pip3 &>/dev/null; then
    echo 'pip3 encontrado. Instalando dependencias...'
    pip3 install -r requirements/base.txt --break-system-packages
else
    echo 'pip3 no encontrado. Instalando pip3...'
    sudo apt update
    sudo apt install -y python3-pip
    pip3 install -r requirements/base.txt --break-system-packages
fi
"

# Mensaje de instalación completa
depriv bash -c "echo 'Instalación completa de theHarvester'"
