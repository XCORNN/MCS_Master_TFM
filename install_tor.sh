#!/bin/bash

# Este script instala Tor en un sistema Debian o basado en Debian

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Verifica la arquitectura de la CPU
ARCH=$(dpkg --print-architecture)
if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" && "$ARCH" != "i386" ]]; then
    echo "Arquitectura no soportada: $ARCH"
    exit 1
fi

# Actualiza el índice de paquetes
echo "Actualizando el índice de paquetes..."
apt update

# Instala las dependencias necesarias
echo "Instalando las dependencias necesarias..."
apt install -y apt-transport-https gnupg

# Agrega la clave del repositorio de Tor
echo "Agregando la clave del repositorio de Tor..."
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/deb.torproject.org-keyring.gpg > /dev/null

# Obtiene el nombre del código de la distribución
DIST=$(lsb_release -c | awk '{print $2}')

# Agrega el repositorio de Tor a sources.list.d
echo "Agregando el repositorio de Tor a sources.list.d..."
echo "deb [signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main" | tee /etc/apt/sources.list.d/tor.list
echo "deb-src [signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main" | tee -a /etc/apt/sources.list.d/tor.list

# Actualiza el índice de paquetes nuevamente
echo "Actualizando el índice de paquetes nuevamente..."
apt update

# Instala Tor y el keyring de Tor
echo "Instalando Tor..."
apt install -y tor deb.torproject.org-keyring

# Inicia y habilita el servicio Tor
echo "Iniciando y habilitando el servicio Tor..."
systemctl start tor
systemctl enable tor

echo "Tor se ha instalado y está ejecutándose."

# Verifica el estado de Tor
systemctl status tor

