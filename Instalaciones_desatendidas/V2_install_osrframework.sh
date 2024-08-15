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

# Actualiza el sistema
sudo apt update

# Instala dependencias necesarias
sudo apt install -y python3 python3-pip python3-venv

# Define la carpeta de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/osrframework"

# Crea la carpeta de destino si no existe
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

# Cambia al directorio de destino y crea un entorno virtual para Python
depriv bash -c "
cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }
python3 -m venv venv
source venv/bin/activate
"

# Instala osrframework en el entorno virtual
depriv bash -c "
cd '$DEST_DIR'
source venv/bin/activate
pip install osrframework
"

# Confirmación de instalación y comando para usar osrframework
depriv bash -c "
echo 'osrframework ha sido instalado correctamente en $DEST_DIR/venv'
echo 'Para ejecutar osrframework, usa el siguiente comando:'
echo 'source $DEST_DIR/venv/bin/activate && osrframework'
"

# Uso
# source /home/$USER/Escritorio/osrframework/venv/bin/activate && osrframework
