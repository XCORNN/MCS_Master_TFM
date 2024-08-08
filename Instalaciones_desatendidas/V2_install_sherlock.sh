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

# Crea el directorio Sherlock en el Escritorio
depriv bash -c "mkdir -p $HOME/Escritorio/sherlock"

# Cambia al directorio Sherlock en el Escritorio
depriv bash -c "cd $HOME/Escritorio/sherlock || { echo 'No se pudo cambiar al directorio $HOME/Escritorio/sherlock.'; exit 1; }"

# Crea un entorno virtual en el directorio Sherlock
depriv bash -c "python3 -m venv venv"
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica que el paquete python3-venv esté instalado.'
    exit 1
fi

# Activa el entorno virtual y instala sherlock-project
depriv bash -c "
source $HOME/Escritorio/sherlock/venv/bin/activate
pip install sherlock-project
if [ \$? -ne 0 ]; then
    echo 'Error al instalar sherlock-project. Verifica que pip esté correctamente configurado.'
    exit 1
fi
"

echo 'Sherlock ha sido instalado correctamente en $HOME/Escritorio/sherlock'
echo 'Para usar Sherlock, activa el entorno virtual y ejecuta sherlock:'
echo 'source $HOME/Escritorio/sherlock/venv/bin/activate && sherlock'
