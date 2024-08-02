#!/bin/bash

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

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

# Crea el directorio de destino si no existe
DEST_DIR="$HOME/Escritorio/TheHarvester"
mkdir -p "$DEST_DIR"
cd "$DEST_DIR" || { echo "No se pudo cambiar al directorio $DEST_DIR."; exit 1; }

# Clonar el repositorio de theHarvester
git clone https://github.com/laramies/theHarvester.git

# Entrar en el directorio de theHarvester
cd theHarvester || { echo "No se pudo cambiar al directorio theHarvester."; exit 1; }

# Crear y activar un entorno virtual para Python
python3 -m venv venv
source venv/bin/activate

# Verifica que pip esté disponible en el entorno virtual
if ! command -v pip &> /dev/null; then
    echo "Error: pip no está disponible en el entorno virtual. Verifica la instalación de pip."
    exit 1
fi

# Instalar las dependencias de theHarvester dentro del entorno virtual
pip install -r requirements/base.txt

echo "Instalación completa de theHarvester"
