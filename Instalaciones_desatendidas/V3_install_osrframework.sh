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
echo "Actualizando el sistema..."
sudo apt update
if [ $? -ne 0 ]; then
    echo "Error al actualizar el sistema. Salida."
    exit 1
fi

# Instala dependencias necesarias
echo "Instalando dependencias necesarias..."
sudo apt install -y python3 python3-pip python3-venv
if [ $? -ne 0 ]; then
    echo "Error al instalar las dependencias necesarias. Salida."
    exit 1
fi

# Define la carpeta de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/osrframework"

# Crea la carpeta de destino si no existe
echo "Creando el directorio $DEST_DIR..."
depriv bash -c "
if [ ! -d '$DEST_DIR' ]; then
    mkdir -p '$DEST_DIR'
    if [ $? -ne 0 ]; then
        echo 'Error al crear el directorio $DEST_DIR. Verifica los permisos.'
        exit 1
    fi
else
    echo 'El directorio $DEST_DIR ya existe.'
fi
"
if [ $? -ne 0 ]; then
    echo "Error al crear el directorio de destino. Salida."
    exit 1
fi

# Cambia al directorio de destino y crea un entorno virtual para Python
echo "Creando un entorno virtual en $DEST_DIR..."
depriv bash -c "
cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica si python3-venv está instalado.'
    exit 1
fi
source venv/bin/activate
"
if [ $? -ne 0 ]; then
    echo "Error al crear o activar el entorno virtual. Salida."
    exit 1
fi

# Instala osrframework en el entorno virtual
echo "Instalando osrframework en el entorno virtual..."
depriv bash -c "
cd '$DEST_DIR'
source venv/bin/activate
pip install osrframework
if [ $? -ne 0 ]; then
    echo 'Error al instalar osrframework. Verifica los permisos y la conectividad.'
    exit 1
fi
"
if [ $? -ne 0 ]; then
    echo "Error al instalar osrframework. Salida."
    exit 1
fi

# Confirmación de instalación y comando para usar osrframework
echo "osrframework ha sido instalado correctamente en $DEST_DIR/venv"
echo "Para ejecutar osrframework, usa el siguiente comando:"
echo "source $DEST_DIR/venv/bin/activate && osrframework"

# Uso
# source /home/$USER/Escritorio/osrframework/venv/bin/activate && osrframework
