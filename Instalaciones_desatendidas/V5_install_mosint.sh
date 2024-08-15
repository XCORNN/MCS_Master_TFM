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
MOSINT_DIR="$INSTALL_DIR/mosint/v3/cmd/mosint"

# Crea el directorio Mosint en el Escritorio
depriv bash -c "mkdir -p '$INSTALL_DIR'"

# Clona el repositorio y realiza las operaciones necesarias
depriv bash -c "
cd '$INSTALL_DIR' || { echo 'No se pudo cambiar al directorio $INSTALL_DIR.'; exit 1; }
git clone https://github.com/alpkeskin/mosint.git
if [ $? -ne 0 ]; then
    echo 'Error al clonar el repositorio de mosint. Verifica la conexión a Internet y los permisos.'
    exit 1
fi
"

# Crea el entorno virtual y activa el entorno virtual
depriv bash -c "
cd '$MOSINT_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_DIR.'; exit 1; }
python3 -m venv '$VENV_DIR'
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica que el paquete python3-venv esté instalado.'
    exit 1
fi
"

# Ejecuta el comando go run main.go para verificar la instalación
depriv bash -c "
cd '$MOSINT_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_DIR.'; exit 1; }
source '$VENV_DIR/bin/activate'
go run main.go -h &>/dev/null
if [ $? -ne 0 ]; then
    echo 'Error al ejecutar go run main.go -h. Verifica la instalación de Go y el código del repositorio.'
    exit 1
fi
"

# Confirmación de instalación y comando para usar mosint
depriv bash -c "
cd '$MOSINT_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_DIR.'; exit 1; }
echo 'mosint ha sido instalado correctamente en $INSTALL_DIR'
echo 'Para usar mosint, activa el entorno virtual con:'
echo 'source $VENV_DIR/bin/activate'
echo 'Y ejecuta el programa con:'
echo 'source $VENV_DIR/bin/activate && go run main.go'
"
