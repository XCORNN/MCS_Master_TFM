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
DEST_DIR="/home/$SUDO_USER/Escritorio/theHarvester"

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

# Clona el repositorio de theHarvester
if [ ! -d "$DEST_DIR/theHarvester" ]; then
    echo "Clonando el repositorio de theHarvester..."
    depriv git clone https://github.com/laramies/theHarvester.git
else
    echo "El repositorio de theHarvester ya está clonado."
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

# Crea y activa un entorno virtual para Python
echo "Creando y activando un entorno virtual para Python..."
depriv bash -c "
cd '$DEST_DIR/theHarvester'
python3 -m venv venv
source venv/bin/activate
"

# Instala las dependencias de theHarvester dentro del entorno virtual
echo "Instalando las dependencias de theHarvester..."
depriv bash -c "
cd '$DEST_DIR/theHarvester'
source venv/bin/activate
pip install -r requirements/base.txt
"

# Crear el archivo .desktop
echo "Creando el archivo .desktop..."
cat <<EOF | tee /usr/share/applications/theHarvester.desktop > /dev/null
[Desktop Entry]
Version=1.0
Name=TheHarvester
Exec=gnome-terminal -- bash -c "cd ~/Escritorio/theHarvester/theHarvester && source venv/bin/activate && python3 theHarvester.py; exec bash"
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=Info-Gath;
EOF

# Cambiar permisos del archivo .desktop
echo "Asignando permisos 644 al archivo .desktop..."
chmod 644 /usr/share/applications/theHarvester.desktop

echo "Instalación completa de theHarvester. Puedes ejecutar el script manualmente usando:"
echo "source ~/Escritorio/theHarvester/theHarvester/venv/bin/activate"
echo "python3 ~/Escritorio/theHarvester/theHarvester/theHarvester.py"
