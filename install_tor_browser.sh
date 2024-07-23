#!/bin/bash

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Directorio de instalación del Tor Browser
TOR_BROWSER_DIR="/opt/tor-browser"

# URL del paquete del Tor Browser
TOR_BROWSER_URL="https://dist.torproject.org/torbrowser/13.5.1/tor-browser-linux-x86_64-13.5.1.tar.xz"

# Nombre del archivo descargado
TOR_BROWSER_TAR="tor-browser-linux-x86_64-13.5.1.tar.xz"

# Crea el directorio de instalación si no existe
mkdir -p "$TOR_BROWSER_DIR"

# Cambia al directorio de instalación
cd "$TOR_BROWSER_DIR"

# Descarga el paquete del Tor Browser
echo "Descargando Tor Browser..."
wget -O "$TOR_BROWSER_TAR" "$TOR_BROWSER_URL"

# Extrae el archivo descargado
echo "Extrayendo Tor Browser..."
tar -xf "$TOR_BROWSER_TAR"

# Cambia al directorio extraído
cd tor-browser_en-US

# Inicia el Navegador Tor
echo "Iniciando Tor Browser..."
./start-tor-browser.desktop &

echo "Tor Browser se ha instalado y está ejecutándose."
