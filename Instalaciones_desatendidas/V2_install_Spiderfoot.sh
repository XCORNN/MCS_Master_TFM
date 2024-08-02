#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Obtiene el directorio de escritorio del usuario actual
DEST_DIR="/home/$SUDO_USER/Escritorio/Spiderfoot"

# Crea el directorio de destino si no existe
depriv bash -c "
if [ ! -d '$DEST_DIR' ]; then
    echo 'Creando el directorio $DEST_DIR...'
    mkdir -p '$DEST_DIR'
    if [ \$? -ne 0 ]; then
        echo 'Error al crear el directorio $DEST_DIR. Verifica los permisos.'
        exit 1
    fi
else
    echo 'El directorio $DEST_DIR ya existe.'
fi
"

# Navega al directorio de destino
cd "$DEST_DIR" || { echo "No se pudo cambiar al directorio $DEST_DIR."; exit 1; }

# Descarga el archivo tar.gz de Spiderfoot
wget https://github.com/smicallef/spiderfoot/archive/refs/tags/v4.0.tar.gz

# Crea y activa un entorno virtual para Python
python3 -m venv venv
source venv/bin/activate

# Instala las dependencias necesarias dentro del entorno virtual
pip install lxml netaddr cherrypy mako requests bs4 pyyaml

# Instala python3-m2crypto usando apt
sudo apt-get install -y python3-m2crypto

# Descomprime el archivo tar.gz y mueve el contenido
tar xzvf v4.0.tar.gz
mv spiderfoot-4.0/* .
rm -rf spiderfoot-4.0

# Instala las dependencias de Spiderfoot desde requirements.txt
sed -i '/pyyaml/d' requirements.txt
pip install -r requirements.txt

echo "Instalación completa de Spiderfoot"
