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

# Instalar Go en la última versión si no está correctamente instalado
GO_VERSION="1.20.6"
GO_TAR="go${GO_VERSION}.linux-amd64.tar.gz"
GO_INSTALL_DIR="/usr/local/go"

# Verificar si la versión de Go ya está instalada
if ! command -v go &> /dev/null || [ "$(go version | awk '{print $3}')" != "go${GO_VERSION}" ]; then
    echo "Instalando Go ${GO_VERSION}..."
    wget "https://go.dev/dl/${GO_TAR}" -O "/tmp/${GO_TAR}"
    sudo tar -C /usr/local -xzf "/tmp/${GO_TAR}"
    rm -f "/tmp/${GO_TAR}"
else
    echo "Go ${GO_VERSION} ya está instalado."
fi

# Configurar variables de entorno
echo "Configurando variables de entorno para Go..."
export GOROOT=$GO_INSTALL_DIR
export PATH=$PATH:$GOROOT/bin

# Añadir configuración al archivo de perfil del usuario
PROFILE_FILE="$HOME/.bashrc"
if [ -f "$HOME/.zshrc" ]; then
    PROFILE_FILE="$HOME/.zshrc"
fi

if ! grep -q "GOROOT" "$PROFILE_FILE"; then
    echo "export GOROOT=$GO_INSTALL_DIR" >> "$PROFILE_FILE"
fi

if ! grep -q "PATH=.*$GOROOT/bin" "$PROFILE_FILE"; then
    echo "export PATH=\$PATH:\$GOROOT/bin" >> "$PROFILE_FILE"
fi

# Recargar el archivo de perfil del usuario
echo "Recargando el perfil del usuario..."
source "$PROFILE_FILE"

# Crea el entorno virtual
depriv bash -c "
cd '$MOSINT_CMD_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_CMD_DIR.'; exit 1; }
python3 -m venv '$VENV_DIR'
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica que el paquete python3-venv esté instalado.'
    exit 1
fi
"

# Verifica la instalación de go y ejecuta el comando go run main.go
depriv bash -c "
cd '$MOSINT_CMD_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_CMD_DIR.'; exit 1; }
source '$VENV_DIR/bin/activate'
go version &>/dev/null
if [ $? -ne 0 ]; then
    echo 'Error: Go no está instalado correctamente o no está en el PATH.'
    exit 1
fi
go run main.go -h &>/dev/null
if [ $? -ne 0 ]; then
    echo 'Error al ejecutar go run main.go -h. Verifica la instalación de Go y el código del repositorio.'
    exit 1
fi
"

# Confirmación de instalación y comandos para usar mosint
depriv bash -c "
cd '$MOSINT_CMD_DIR' || { echo 'No se pudo cambiar al directorio $MOSINT_CMD_DIR.'; exit 1; }
echo 'mosint ha sido instalado correctamente en $INSTALL_DIR'
echo 'Para usar mosint, activa el entorno virtual con:'
echo 'source $VENV_DIR/bin/activate'
echo 'Y ejecuta el programa con:'
echo 'source $VENV_DIR/bin/activate && go run main.go'
"
