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

# Definir la carpeta de destino
DEST_DIR="/home/$SUDO_USER/Escritorio/Mosint"

# Actualizar la lista de paquetes
sudo apt update

# Instalar Go si no está instalado
if ! command -v go &>/dev/null; then
    sudo apt install -y golang-go
else
    echo "Go ya está instalado."
fi

# Instalar Python3 y pip si no están instalados
if ! command -v python3 &>/dev/null; then
    sudo apt install -y python3 python3-pip
else
    echo "Python3 ya está instalado."
fi

# Crear directorio de destino y cambiar a él como el usuario normal
depriv bash -c "mkdir -p \"$DEST_DIR\" && cd \"$DEST_DIR\""

# Clonar el repositorio como el usuario normal
depriv bash -c "cd \"$DEST_DIR\" && git clone https://github.com/alpkeskin/mosint"

# Cambiar al directorio del código y crear un entorno virtual para Python
depriv bash -c "cd \"$DEST_DIR/mosint/v3/cmd/mosint\" && python3 -m venv venv"

# Activar el entorno virtual y instalar las dependencias dentro del entorno virtual
depriv bash -c "source \"$DEST_DIR/mosint/v3/cmd/mosint/venv/bin/activate\" && pip install -r \"$DEST_DIR/mosint/v3/cmd/mosint/requirements.txt\""

# Ejecutar el comando Go como el usuario normal
depriv bash -c "cd \"$DEST_DIR/mosint/v3/cmd/mosint\" && go run main.go -h &>/dev/null"

# Mensaje de instalación completada
echo "Instalación completada. Para utilizar Mosint:"
echo "1. Activa el entorno virtual con: source $DEST_DIR/mosint/v3/cmd/mosint/venv/bin/activate"
echo "2. Ejecuta Mosint con: go run main.go [opciones]"
