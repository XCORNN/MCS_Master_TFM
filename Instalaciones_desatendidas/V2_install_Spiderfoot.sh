#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verifica e instala python3-venv si no está instalado
echo "Verificando e instalando python3-venv..."
if ! dpkg -l | grep -qw python3-venv; then
    echo "python3-venv no está instalado. Instalando..."
    sudo apt-get update
    sudo apt-get install -y python3-venv
    if [ $? -ne 0 ]; then
        echo "Error al instalar python3-venv. Verifica los permisos y la conexión a Internet."
        exit 1
    fi
else
    echo "python3-venv ya está instalado."
fi

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

# Verifica que el entorno virtual se ha creado correctamente
if [ ! -f "venv/bin/activate" ]; then
    echo "Error: No se pudo crear el entorno virtual. Verifica la instalación de python3-venv."
    exit 1
fi

# Activa el entorno virtual
source venv/bin/activate

# Verifica que pip esté disponible en el entorno virtual
if ! command -v pip &> /dev/null; then
    echo "Error: pip no está disponible en el entorno virtual. Verifica la instalación de pip."
    exit 1
fi

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
