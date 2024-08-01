#!/bin/bash

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar la extensión de escritorio
echo "Instalando la extensión de escritorio..."
sudo apt install gnome-shell-extension-desktop-icons-ng -y

# Crear un directorio para los accesos directos en el escritorio si no existe
DESKTOP_DIR="$HOME/Escritorio"
mkdir -p "$DESKTOP_DIR"

# Crear una carpeta de prueba en el escritorio
TEST_DIR="$DESKTOP_DIR/CarpetaDePrueba"
mkdir -p "$TEST_DIR"

# Reiniciar GNOME Shell para aplicar los cambios
echo "Reiniciando GNOME Shell para aplicar los cambios..."
sudo pkill -9 ^gnome-shell

# Esperar a que el proceso de GNOME Shell se reinicie
echo "Esperando a que GNOME Shell se reinicie..."
while ! pgrep -u $USER gnome-shell > /dev/null; do sleep 1; done

# Habilitar la extensión usando gnome-extensions
echo "Habilitando la extensión de escritorio..."
gnome-extensions enable ding@rastersoft.com

echo "La extensión ha sido instalada, habilitada y GNOME Shell ha sido reiniciado. La carpeta de prueba ha sido creada en el escritorio."
