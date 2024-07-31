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

# Crear un archivo .desktop que apunte a la carpeta de prueba
echo "Creando el acceso directo en el escritorio..."
cat <<EOF > "$DESKTOP_DIR/AccesoCarpetaDePrueba.desktop"
[Desktop Entry]
Version=1.0
Name=Carpeta de Prueba
Comment=Este es un acceso directo a una carpeta de prueba
Exec=nautilus $TEST_DIR
Icon=folder
Terminal=false
Type=Application
Categories=Utility;
EOF

# Asegurarse de que el archivo .desktop sea ejecutable
chmod +x "$DESKTOP_DIR/AccesoCarpetaDePrueba.desktop"

# Informar al usuario que reinicie la sesión
echo "La extensión ha sido instalada y el acceso directo ha sido creado en el escritorio."
echo "Por favor, cierra y vuelve a iniciar sesión para que la extensión se aplique correctamente."
