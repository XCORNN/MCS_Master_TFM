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
DEST_DIR="/home/$SUDO_USER/Escritorio/sherlock"

# Actualiza el sistema
sudo apt update
sudo apt upgrade -y

# Instala dependencias necesarias incluyendo python3-pip y python3-venv
sudo apt install -y python3-pip python3-venv

# Crea el directorio Sherlock en el Escritorio del usuario
depriv bash -c "mkdir -p '$DEST_DIR'"

# Cambia al directorio Sherlock en el Escritorio del usuario
depriv bash -c "cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }"

# Verifica si el entorno virtual ya existe y lo elimina si es necesario
if [ -d "$DEST_DIR/venv" ]; then
    echo "El entorno virtual ya existe. Se eliminará antes de crear uno nuevo."
    depriv bash -c "rm -rf '$DEST_DIR/venv'"
fi

# Crea un entorno virtual en el directorio Sherlock
depriv bash -c "python3 -m venv '$DEST_DIR/venv'"
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica que el paquete python3-venv esté instalado y que la ruta sea correcta.'
    exit 1
fi

# Verifica si el entorno virtual fue creado correctamente
if [ ! -f "$DEST_DIR/venv/bin/activate" ]; then
    echo 'No se encontró el script activate en el entorno virtual. Verifica la creación del entorno virtual.'
    exit 1
fi

# Activa el entorno virtual e instala sherlock-project
depriv bash -c "
source '$DEST_DIR/venv/bin/activate'
pip install --upgrade pip
if [ \$? -ne 0 ]; then
    echo 'Error al actualizar pip. Verifica que pip esté correctamente configurado.'
    exit 1
fi
pip install sherlock-project
if [ \$? -ne 0 ]; then
    echo 'Error al instalar sherlock-project. Verifica que el entorno virtual esté activado.'
    exit 1
fi
"

# Confirmación de instalación
echo 'Sherlock ha sido instalado correctamente en $DEST_DIR'
echo 'Para usar Sherlock, activa el entorno virtual y ejecuta sherlock:'
echo 'source '$DEST_DIR'/venv/bin/activate && sherlock'


#Uso
# source /home/$USER/Escritorio/sherlock/venv/bin/activate && sherlock
