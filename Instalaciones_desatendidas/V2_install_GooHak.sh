#!/bin/bash

# Variables
REPO_URL="https://github.com/1N3/Goohak.git"
USER_HOME=$(eval echo ~$SUDO_USER)
DESKTOP_DIR="$USER_HOME/Escritorio/GooHak"

# Verificar si xdg-open está instalado
if ! command -v xdg-open &> /dev/null; then
    echo "[*] xdg-open no está instalado. Instalándolo..."
    sudo apt-get update
    sudo apt-get install -y xdg-utils
else
    echo "[*] xdg-open ya está instalado."
fi

# Crear carpeta en el escritorio
echo "[*] Creando carpeta en el escritorio..."
mkdir -p "$DESKTOP_DIR"

# Moverse a la carpeta y clonar el repositorio
cd "$DESKTOP_DIR"
echo "[*] Clonando el repositorio..."
git clone "$REPO_URL"

# Cambiar permisos del directorio clonado
echo "[*] Cambiando permisos del directorio clonado..."
sudo chmod +x "$DESKTOP_DIR/Goohak/goohak"

# Mensaje de éxito
echo "[*] Instalación completada con éxito. GooHak está listo para usarse."
