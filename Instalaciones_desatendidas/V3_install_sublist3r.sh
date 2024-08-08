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
sudo apt install -y git python3 python3-pip python3-venv

# Define la carpeta de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/Sublist3r"

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

# Clona el repositorio de Sublist3r en el directorio del usuario
depriv bash -c "
cd '$DEST_DIR'
if [ ! -d 'Sublist3r/.git' ]; then
    echo 'Clonando el repositorio de Sublist3r en $DEST_DIR...'
    git clone https://github.com/aboul3la/Sublist3r.git .
    if [ $? -ne 0 ]; then
        echo 'Error al clonar el repositorio. Verifica la conexión a Internet y los permisos.'
        exit 1
    fi
else
    echo 'El repositorio de Sublist3r ya está clonado en $DEST_DIR.'
fi
"

# Instala dependencias de Python en el entorno virtual
depriv bash -c "
cd '$DEST_DIR'
source venv/bin/activate
if [ -f 'requirements.txt' ]; then
    echo 'Instalando dependencias desde requirements.txt...'
    venv/bin/pip install -r requirements.txt
else
    echo 'Archivo requirements.txt no encontrado.'
    exit 1
fi
"

# Confirmación de instalación
depriv bash -c "echo 'Sublist3r ha sido instalado correctamente en $DEST_DIR'"
