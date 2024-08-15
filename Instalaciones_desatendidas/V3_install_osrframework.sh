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

# Instalar paquetes necesarios
depriv sudo apt update
depriv sudo apt install -y python3 python3-pip python3-venv

# Crear y activar el entorno virtual
depriv python3 -m venv osrframework-venv
depriv source osrframework-venv/bin/activate <<EOF
# Instalar paquetes en el entorno virtual
pip install osrframework
pip install urllib3==1.26.15
pip install --upgrade cfscrape
pip install --upgrade osrframework
EOF

echo "Instalación completada."
