#!/bin/bash

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Define el directorio de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/TheHarvester"

# Crea el directorio de destino si no existe
if [ ! -d "$DEST_DIR" ]; then
    echo "Creando el directorio $DEST_DIR..."
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Error al crear el directorio $DEST_DIR. Verifica los permisos."
        exit 1
    fi
else
    echo "El directorio $DEST_DIR ya existe."
fi

# Navega al directorio de destino
cd "$DEST_DIR" || { echo "No se pudo cambiar al directorio $DEST_DIR."; exit 1; }

# Clona el repositorio de theHarvester
git clone https://github.com/laramies/theHarvester.git .

# Verifica e instala python3-venv si no está instalado
echo "Verificando e instalando python3-venv..."
if ! dpkg -l | grep -qw python3-venv; then
    echo "python3-venv no está instalado. Instalando..."
    apt-get update
    apt-get install -y python3-venv
    if [ $? -ne 0 ]; then
        echo "Error al instalar python3-venv. Verifica los permisos y la conexión a Internet."
        exit 1
    fi
else
    echo "python3-venv ya está instalado."
fi

# Crea y activa el entorno virtual para Python
python3 -m venv venv
source venv/bin/activate

# Instala las dependencias de theHarvester dentro del entorno virtual
pip install -r theHarvester/requirements/base.txt
deactivate

# Mueve los archivos necesarios al directorio raíz y limpia la estructura
echo "Moviendo archivos al directorio raíz y limpiando la estructura..."
mv theHarvester/* ./
rm -rf theHarvester

echo "Instalación completa de theHarvester. Puedes ejecutar el script manualmente usando:"
echo "source ~/Escritorio/TheHarvester/venv/bin/activate"
echo "python3 ~/Escritorio/TheHarvester/theHarvester.py"
