#!/bin/bash

# Verifica si el usuario tiene permisos de sudo
if ! sudo -v; then
    echo "El usuario no tiene permisos de sudo. Por favor, asegúrate de tener permisos para instalar paquetes."
    exit 1
fi

# Obtiene el directorio de escritorio del usuario actual
DEST_DIR="$HOME/Escritorio/Recon-NG"

# Crea el directorio de destino si no existe
if [ ! -d "$DEST_DIR" ]; then
    echo "Creando el directorio $DEST_DIR..."
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Error al crear el directorio $DEST_DIR. Verifica los permisos."
        exit 1
    fi
else
    echo "El directorio $DEST_DIR ya existe."
fi

# Actualiza la lista de paquetes y asegura que los repositorios están al día
sudo apt update

# Instala las dependencias necesarias para la construcción y ejecución de Recon-NG
sudo apt install -y build-essential git python3 python3-pip python3-venv

# Clona el repositorio de Recon-NG desde GitHub en el directorio del usuario
if [ ! -d "$DEST_DIR/.git" ]; then
    echo "Clonando el repositorio de Recon-NG en $DEST_DIR..."
    git clone https://github.com/lanmaster53/recon-ng.git "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Error al clonar el repositorio. Verifica la conexión a Internet y los permisos."
        exit 1
    fi
else
    echo "El repositorio de Recon-NG ya está clonado en $DEST_DIR."
fi

# Cambia al directorio de Recon-NG
cd "$DEST_DIR" || { echo "No se pudo cambiar al directorio $DEST_DIR."; exit 1; }

# Crea un entorno virtual para Python y actívalo
python3 -m venv venv
source venv/bin/activate

# Comprueba si el archivo REQUIREMENTS existe antes de intentar instalar las dependencias
if [ -f "REQUIREMENTS" ]; then
    echo "Instalando dependencias desde REQUIREMENTS..."
    pip install -r REQUIREMENTS
elif [ -f "requirements.txt" ]; then
    echo "Instalando dependencias desde requirements.txt..."
    pip install -r requirements.txt
else
    echo "Archivo de dependencias no encontrado. Instalando pyyaml y requests manualmente..."
    pip install pyyaml requests
fi

# echo de Instalacion completa
echo "Instalando Completa de Recon-NG"
