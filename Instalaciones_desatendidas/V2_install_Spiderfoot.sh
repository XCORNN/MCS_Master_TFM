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

# Instalación de Spiderfoot
echo "Instalando Spiderfoot..."
depriv bash -c 'mkdir -p ~/Escritorio/Spiderfoot && cd ~/Escritorio/Spiderfoot && wget https://github.com/smicallef/spiderfoot/archive/refs/tags/v4.0.tar.gz'

# Instalación de dependencias
echo "Instalando dependencias..."
if [ which pip3 &>/dev/null ]; then
    depriv sudo pip3 install lxml netaddr cherrypy mako requests bs4 pyyaml --break-system-packages
else
    depriv sudo apt-get install -y python3-pip
    depriv sudo pip3 install lxml netaddr cherrypy mako requests bs4 pyyaml --break-system-packages
fi

# Instalación de m2crypto
depriv sudo apt-get install python3-m2crypto

# Extracción e instalación de Spiderfoot
echo "Extrayendo e instalando Spiderfoot..."
depriv bash -c 'tar xzvf v4.0.tar.gz && cd spiderfoot-4.0 && sed -i "/pyyaml/d" requirements.txt && pip3 install -r requirements.txt --break-system-packages'

echo "Script completado."
