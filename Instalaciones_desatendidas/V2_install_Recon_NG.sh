#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verifica si el usuario tiene permisos de sudo
if ! sudo -v; then
    echo "El usuario no tiene permisos de sudo. Por favor, asegúrate de tener permisos para instalar paquetes."
    exit 1
fi

# Obtiene el directorio de escritorio del usuario actual
DEST_DIR="/home/$SUDO_USER/Escritorio/Recon-NG"

# Crea el directorio de destino si no existe
depriv bash -c "
if [ ! -d '$DEST_DIR' ]; then
    echo 'Creando el directorio $DEST_DIR...'
    mkdir -p '$DEST_DIR'
    if [ $? -ne 0 ]; then
        echo 'Error al crear el directorio $DEST_DIR. Verifica los permisos.'
        exit 1
    fi
else
    echo 'El directorio $DEST_DIR ya existe.'
fi
"

# Actualiza la lista de paquetes y asegura que los repositorios están al día
sudo apt update

# Instala las dependencias necesarias para la construcción y ejecución de Recon-NG
sudo apt install -y build-essential git python3 python3-pip python3-venv

# Clona el repositorio de Recon-NG desde GitHub en el directorio del usuario
depriv bash -c "
if [ ! -d '$DEST_DIR/.git' ]; then
    echo 'Clonando el repositorio de Recon-NG en $DEST_DIR...'
    git clone https://github.com/lanmaster53/recon-ng.git '$DEST_DIR'
    if [ $? -ne 0 ]; then
        echo 'Error al clonar el repositorio. Verifica la conexión a Internet y los permisos.'
        exit 1
    fi
else
    echo 'El repositorio de Recon-NG ya está clonado en $DEST_DIR.'
fi
"

# Cambia al directorio de Recon-NG y crea un entorno virtual para Python
depriv bash -c "
cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }
python3 -m venv venv
source venv/bin/activate
"

# Instala las dependencias en el entorno virtual
depriv bash -c "
cd '$DEST_DIR'
source venv/bin/activate
if [ -f 'REQUIREMENTS' ]; then
    echo 'Instalando dependencias desde REQUIREMENTS...'
    venv/bin/pip install -r REQUIREMENTS
elif [ -f 'requirements.txt' ]; then
    echo 'Instalando dependencias desde requirements.txt...'
    venv/bin/pip install -r requirements.txt
else
    echo 'Archivo de dependencias no encontrado. Instalando pyyaml y requests manualmente...'
    venv/bin/pip install pyyaml requests
fi
"

# echo de Instalacion completa
depriv bash -c "echo 'Instalación completa de Recon-NG'"


#Uso:
#Primero, abre una terminal y navega al directorio donde instalaste Recon-NG. Luego activa el entorno virtual:
#  cd /home/$SUDO_USER/Escritorio/Recon-NG
#  source venv/bin/activate
# Una vez activado y dentro del (venv)
#  ./recon-ng
