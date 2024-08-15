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

# Actualiza el sistema
sudo apt update

# Instala las dependencias necesarias incluyendo golang-go y python3-venv
sudo apt install -y golang-go python3 python3-pip python3-venv git

# Define las rutas
INSTALL_DIR="/home/$SUDO_USER/Escritorio/Mosint"
VENV_DIR="$INSTALL_DIR/venv"
MOSINT_REPO_DIR="$INSTALL_DIR/mosint"
MOSINT_CMD_DIR="$MOSINT_REPO_DIR/v3/cmd/mosint"

# Crea el directorio Mosint en el Escritorio
depriv bash -c "mkdir -p '$INSTALL_DIR'"

# Clona el repositorio mosint en la subcarpeta
depriv bash -c "
cd '$INSTALL_DIR' || { echo 'No se pudo cambiar al directorio $INSTALL_DIR.'; exit 1; }
if [ ! -d 'mosint' ]; then
    git clone https://github.com/alpkeskin/mosint.git
    if [ $? -ne 0 ]; then
        echo 'Error al clonar el repositorio de mosint. Verifica la conexión a Internet y los permisos.'
        exit 1
    fi
fi
"

# Crea el entorno virtual
depriv bash -c "
cd '$MOSINT_CMD_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_CMD_DIR.'; exit 1; }
python3 -m venv '$VENV_DIR'
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica que el paquete python3-venv esté instalado.'
    exit 1
fi
"

# Verifica la instalación de go
depriv bash -c "
cd '$MOSINT_CMD_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_CMD_DIR.'; exit 1; }
source '$VENV_DIR/bin/activate'
go version &>/dev/null
if [ $? -ne 0 ]; then
    echo 'Error: Go no está instalado correctamente o no está en el PATH.'
    exit 1
fi
"

# Confirmación de instalación y comandos para usar mosint
depriv bash -c "
echo 'mosint ha sido instalado correctamente en $INSTALL_DIR'
echo 'Para usar mosint, sigue estos pasos:'
echo '1. Cambia al directorio donde está el archivo main.go con:'
echo '   cd $MOSINT_CMD_DIR'
echo '2. Activa el entorno virtual con:'
echo '   source $VENV_DIR/bin/activate'
echo '3. Ejecuta el programa con:'
echo '   go run main.go [opciones]'
echo 'Nota: Asegúrate de que Go esté correctamente instalado y configurado en tu sistema.'
"
