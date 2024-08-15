#!/bin/bash

# Asegurar que el PATH contenga los directorios necesarios
export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

# Verificar si es root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

# Variables de entorno para usuario y su home
USER_HOME=$(eval echo ~$SUDO_USER)
BURP_DIR="$USER_HOME/Escritorio/Burpsuite"

# Actualizar lista de paquetes e instalar megatools
apt update
apt install -y megatools wget

# Crear directorio para Burp Suite y asignar permisos
mkdir -p "$BURP_DIR"
chown $SUDO_USER:$SUDO_USER "$BURP_DIR"

# Descargar Burp Suite con megatools
sudo -u $SUDO_USER megadl 'https://mega.nz/file/EQ4wnToA#rrUPgqTLszJ1RfN8hmNLsMO-X2fNqv6MXL7tfF0iJU0' --path="$BURP_DIR"

# Verificar que el archivo se haya descargado correctamente
BURP_INSTALLER="$BURP_DIR/burpsuite_community_linux_v2024_5_5.sh"

if [ ! -f "$BURP_INSTALLER" ]; then
    echo "Error: El archivo Burp Suite no se descargó correctamente."
    exit 1
fi

# Hacer ejecutable el script de Burp Suite
chmod +x "$BURP_INSTALLER"
chown $SUDO_USER:$SUDO_USER "$BURP_INSTALLER"

# Verificar la versión de Java
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

# Instalar Java si es necesario
if [[ -z "$java_version" ]] || [[ "$java_version" != "21"* ]]; then
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb -O "$BURP_DIR/jdk-21_linux-x64_bin.deb"
    dpkg -i "$BURP_DIR/jdk-21_linux-x64_bin.deb"
    rm "$BURP_DIR/jdk-21_linux-x64_bin.deb"  # Eliminar archivo de instalación de Java
fi

# Ejecutar el instalador de Burp Suite en modo silencioso
sudo -u $SUDO_USER "$BURP_INSTALLER" -q -dir "$BURP_DIR"

# Limpiar archivos temporales
rm "$BURP_INSTALLER"  # Eliminar el instalador de Burp Suite

echo "Instalación completada y archivos temporales eliminados."
