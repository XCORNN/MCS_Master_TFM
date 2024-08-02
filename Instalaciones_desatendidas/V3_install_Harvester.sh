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
if [ "$(id -u)" != "0" ]; then
   echo "Este script debe ejecutarse como root" 
   exit 1
fi

# Define el directorio de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/TheHarvester"

# Crea el directorio de destino si no existe
if [ ! -d "$DEST_DIR" ]; then
    echo "Creando el directorio $DEST_DIR..."
    mkdir -p "$DEST_DIR" || { echo "Error al crear el directorio $DEST_DIR. Verifica los permisos."; exit 1; }
else
    echo "El directorio $DEST_DIR ya existe."
fi

# Navega al directorio de destino
cd "$DEST_DIR" || { echo "No se pudo cambiar al directorio $DEST_DIR."; exit 1; }

# Clona el repositorio de theHarvester en una carpeta temporal
TEMP_DIR=$(mktemp -d)
if ! depriv git clone https://github.com/laramies/theHarvester "$TEMP_DIR"; then
  echo "Error al clonar el repositorio de theHarvester."
  exit 1
fi

# Mueve los archivos del repositorio clonado al directorio de destino y limpia la carpeta temporal
echo "Moviendo archivos al directorio destino y limpiando la carpeta temporal..."
depriv bash -c "
mv $TEMP_DIR/* $DEST_DIR/
rm -rf $TEMP_DIR
" || { echo "Error al mover archivos y limpiar la carpeta temporal."; exit 1; }

# Verifica e instala python3-venv si no está instalado
echo "Verificando e instalando python3-venv..."
if ! dpkg -l | grep -qw python3-venv; then
    echo "python3-venv no está instalado. Instalando..."
    apt-get update && apt-get install -y python3-venv || { echo "Error al instalar python3-venv."; exit 1; }
else
    echo "python3-venv ya está instalado."
fi

# Crea y activa un entorno virtual para Python
echo "Creando y activando el entorno virtual..."
depriv bash -c "
python3 -m venv venv
source venv/bin/activate
pip install -r requirements/base.txt
" || { echo "Error al crear el entorno virtual o instalar dependencias."; exit 1; }

echo "Instalación completa de theHarvester. Puedes ejecutar el script manualmente usando:"
echo "source ~/Escritorio/TheHarvester/venv/bin/activate"
echo "python3 ~/Escritorio/TheHarvester/theHarvester.py"
