#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script debe ejecutarse como root"
    exit 1
fi

# Instalación de Malt
echo "Instalando Malt..."
mkdir -p /home/$SUDO_USER/Escritorio/Maltego
cd /home/$SUDO_USER/Escritorio/Maltego

wget https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.7.0.deb

export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin

dpkg -i /home/$SUDO_USER/Escritorio/Maltego/Maltego.v4.7.0.deb

# Instalación de Java
echo "Instalando Java..."
apt update
apt install -y default-jre
apt install -y default-jdk

# Finaliza en el directorio del usuario que invocó sudo
echo "Finalizando en el directorio del usuario '$SUDO_USER'..."
depriv bash -c 'cd ~/Escritorio && echo "Estamos en el directorio de Escritorio de $SUDO_USER" && ls'

echo "Script completado."
