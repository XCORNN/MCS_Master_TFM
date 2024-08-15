#!/bin/bash

# Función para ejecutar comandos como el usuario que invocó sudo
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

# Verifica si pip3 está instalado, si no, lo instala
if ! command -v pip3 &> /dev/null; then
    echo "pip3 no está instalado. Instalando..."
    sudo apt update
    sudo apt install -y python3-pip
fi

# Verifica si virtualenv está instalado, si no, lo instala
if ! pip3 show virtualenv &> /dev/null; then
    echo "virtualenv no está instalado. Instalando..."
    pip3 install virtualenv --user
fi

# Crea el entorno virtual en el directorio del usuario
echo "Creando entorno virtual..."
depriv mkdir -p $HOME/osrframework-venv
depriv virtualenv $HOME/osrframework-venv

# Activa el entorno virtual e instala OSRFramework en él
echo "Instalando OSRFramework en el entorno virtual..."
source $HOME/osrframework-venv/bin/activate
pip install osrframework

# Copia los scripts a un directorio accesible para el usuario
echo "Copiando scripts a ~/Escritorio/osrframework..."
depriv mkdir -p $HOME/Escritorio/osrframework
depriv cp -r ~/.local/bin/* $HOME/Escritorio/osrframework

# Mensaje final para el usuario
echo "Instalación completa. Puedes usar el entorno virtual con 'source $HOME/osrframework-venv/bin/activate'."
echo "Recuerda desactivar el entorno virtual con 'deactivate' cuando hayas terminado."

# Salida del script
exit 0
