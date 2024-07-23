#!/bin/bash

# Este script instala Tor en un sistema Debian

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
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
wget -qO - https://deb.torproject.org/torproject.org/pool/main/0/0xEF6E286DDA85EA2A4BA7DE684E2C6E8793298290.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg

# Agrega el repositorio de Tor a sources.list.d
echo "Agregando el repositorio de Tor a sources.list.d..."
echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org buster main" | tee /etc/apt/sources.list.d/tor.list
echo "deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org buster main" | tee -a /etc/apt/sources.list.d/tor.list

# Actualiza el índice de paquetes nuevamente
echo "Actualizando el índice de paquetes nuevamente..."
apt update

# Instala Tor
echo "Instalando Tor..."
apt install -y tor deb.torproject.org-keyring

# Inicia y habilita el servicio Tor
echo "Iniciando y habilitando el servicio Tor..."
systemctl start tor
systemctl enable tor

echo "Tor se ha instalado y está ejecutándose."

# Verifica el estado de Tor
systemctl status tor
