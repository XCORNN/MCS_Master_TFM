#!/bin/bash

# Este script instala Tor en un sistema Debian o basado en Debian

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Actualiza el índice de paquetes e instala apt-transport-https
echo "Instalando apt-transport-https..."
apt update
apt install -y apt-transport-https

# Agrega la clave del repositorio de Tor
echo "Agregando la clave del repositorio de Tor..."
wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor -o /usr/share/keyrings/deb.torproject.org-keyring.gpg

# Obtiene el nombre del código de la distribución
DIST=$(lsb_release -c | awk '{print $2}')

# Agrega el repositorio de Tor a sources.list.d
echo "Agregando el repositorio de Tor a sources.list.d..."
echo "deb [signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main" > /etc/apt/sources.list.d/tor.list
echo "deb-src [signed-by=/usr/share/keyrings/deb.torproject.org-keyring.gpg] https://deb.torproject.org/torproject.org $DIST main" >> /etc/apt/sources.list.d/tor.list

# Actualiza el índice de paquetes e instala Tor y el keyring de Tor
echo "Actualizando el índice de paquetes e instalando Tor..."
apt update
apt install -y tor deb.torproject.org-keyring

# Inicia y habilita el servicio Tor
echo "Iniciando y habilitando el servicio Tor..."
systemctl start tor
systemctl enable tor

echo "Tor se ha instalado y está ejecutándose."

# Verifica el estado de Tor
systemctl status tor
