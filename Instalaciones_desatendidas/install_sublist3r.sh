#!/bin/bash

# Actualizar el sistema
sudo apt update

# Instalar dependencias necesarias
sudo apt install -y git python3 python3-pip

# Definir la carpeta de destino
DEST_DIR="/home/$USER/Escritorio/Sublist3r"

# Crear la carpeta de destino
mkdir -p "$DEST_DIR"

# Cambiar al directorio de destino
cd "$DEST_DIR"

# Clonar el repositorio de Sublist3r
git clone https://github.com/aboul3la/Sublist3r.git .

# Instalar dependencias de Python
pip3 install --break-system-packages -r requirements.txt

# Confirmación de instalación
echo "Sublist3r ha sido instalado correctamente en $DEST_DIR"
