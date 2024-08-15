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

# Verifica e instala python3-pip y virtualenv si no están instalados
if ! command -v pip3 &> /dev/null; then
    echo "pip3 no está instalado. Instalando..."
    sudo apt update
    sudo apt install -y python3-pip
fi

if ! pip3 show virtualenv &> /dev/null; then
    echo "virtualenv no está instalado. Instalando..."
    pip3 install virtualenv --user
fi

# Configura el entorno virtual
echo "Creando entorno virtual..."
depriv mkdir -p $HOME/osrframework-venv
depriv virtualenv $HOME/osrframework-venv

# Activa el entorno virtual e instala OSRFramework
echo "Instalando OSRFramework en el entorno virtual..."
source $HOME/osrframework-venv/bin/activate
pip install osrframework

# Copia los scripts a un directorio accesible
echo "Copiando scripts a ~/Escritorio/osrframework..."
mkdir -p $HOME/Escritorio/osrframework
cp -r ~/.local/bin/* $HOME/Escritorio/osrframework

echo "Instalación completa. Puedes usar el entorno virtual con 'source $HOME/osrframework-venv/bin/activate'."

# Mensaje final
echo "Para activar el entorno virtual, usa el comando 'source $HOME/osrframework-venv/bin/activate'."
echo "Recuerda desactivar el entorno virtual con 'deactivate' cuando hayas terminado."

# Salida del script
exit 0
