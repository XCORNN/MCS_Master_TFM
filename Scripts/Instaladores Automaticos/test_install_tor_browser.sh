#!/bin/bash

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Directorio de instalación del Tor Browser
TOR_BROWSER_DIR="/opt/tor-browser"

# URL del paquete del Tor Browser y su firma
TOR_BROWSER_URL="https://dist.torproject.org/torbrowser/13.5.1/tor-browser-linux-x86_64-13.5.1.tar.xz"
TOR_BROWSER_SIG_URL="https://dist.torproject.org/torbrowser/13.5.1/tor-browser-linux-x86_64-13.5.1.tar.xz.asc"
TOR_GPG_KEY_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/EF6E286DDA85EA2A4BA7DE684E2C6E8793298290"

# Nombre del archivo descargado
TOR_BROWSER_TAR="tor-browser-linux-x86_64-13.5.1.tar.xz"
TOR_BROWSER_SIG="tor-browser-linux-x86_64-13.5.1.tar.xz.asc"
TOR_GPG_KEY="torproject-key.asc"

# Verifica si wget y gpg están instalados, si no lo están, lo instala
if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null
then
    echo "wget o gpg no están instalados. Instalando..."
    apt update
    apt install -y wget gnupg
fi

# Crea el directorio de instalación si no existe
mkdir -p "$TOR_BROWSER_DIR"

# Cambia al directorio de instalación
cd "$TOR_BROWSER_DIR"

# Descarga el paquete del Tor Browser y su firma
echo "Descargando Tor Browser y su firma..."
wget -O "$TOR_BROWSER_TAR" "$TOR_BROWSER_URL"
wget -O "$TOR_BROWSER_SIG" "$TOR_BROWSER_SIG_URL"

# Descarga la clave pública de GPG
echo "Descargando la clave pública de GPG..."
wget -O "$TOR_GPG_KEY" "$TOR_GPG_KEY_URL"

# Importa la clave pública de GPG
echo "Importando la clave pública de GPG..."
gpg --import "$TOR_GPG_KEY"

# Verifica la firma del paquete
echo "Verificando la firma del paquete..."
gpg --verify "$TOR_BROWSER_SIG" "$TOR_BROWSER_TAR"

# Extrae el archivo descargado
echo "Extrayendo Tor Browser..."
tar -xf "$TOR_BROWSER_TAR"

echo "Tor Browser ha sido instalado en $TOR_BROWSER_DIR."
