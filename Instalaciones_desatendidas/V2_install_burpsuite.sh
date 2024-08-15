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
SUDO_USER_PATH="$USER_HOME/Escritorio/burpsuite"

# Actualizar lista de paquetes e instalar megatools
apt update
apt install -y megatools wget

# Crear directorio para Burp Suite y asignar permisos
mkdir -p "$SUDO_USER_PATH"
chown $SUDO_USER:$SUDO_USER "$SUDO_USER_PATH"

# Verificar la versión de Java
java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')

# Instalar Java si es necesario
if [[ -z "$java_version" ]] || [[ "$java_version" != "21"* ]]; then
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.deb -O "$SUDO_USER_PATH/jdk-21_linux-x64_bin.deb"
    dpkg -i "$SUDO_USER_PATH/jdk-21_linux-x64_bin.deb"
    rm "$SUDO_USER_PATH/jdk-21_linux-x64_bin.deb"
fi

# Descargar Burp Suite con megatools
sudo -u $SUDO_USER megadl 'https://mega.nz/file/EQ4wnToA#rrUPgqTLszJ1RfN8hmNLsMO-X2fNqv6MXL7tfF0iJU0' -o "$SUDO_USER_PATH"

# Hacer ejecutable el script de Burp Suite
chmod +x "$SUDO_USER_PATH/burpsuite_community_linux_v2024_5_5.sh"
chown $SUDO_USER:$SUDO_USER "$SUDO_USER_PATH/burpsuite_community_linux_v2024_5_5.sh"

# Ejecutar el instalador de Burp Suite en modo silencioso
sudo -u $SUDO_USER "$SUDO_USER_PATH/burpsuite_community_linux_v2024_5_5.sh" -q -dir "$SUDO_USER_PATH"
