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
depriv mkdir -p ~/Escritorio/Spiderfoot
depriv bash -c 'cd ~/Escritorio/Spiderfoot && wget https://github.com/smicallef/spiderfoot/archive/refs/tags/v4.0.tar.gz'

# Instalación de dependencias
echo "Instalando dependencias..."
if command -v pip3 &>/dev/null; then
    depriv pip3 install lxml netaddr cherrypy mako requests bs4 pyyaml --break-system-packages
else
    depriv apt-get install -y python3-pip
    depriv pip3 install lxml netaddr cherrypy mako requests bs4 pyyaml --break-system-packages
fi

# Instalación de m2crypto
depriv apt-get install -y python3-m2crypto

# Extracción e instalación de Spiderfoot
echo "Extrayendo e instalando Spiderfoot..."
depriv bash -c 'cd ~/Escritorio/Spiderfoot && tar xzvf v4.0.tar.gz && cd spiderfoot-4.0 && sed -i "/pyyaml/d" requirements.txt && pip3 install -r requirements.txt --break-system-packages'

echo "Script completado."
