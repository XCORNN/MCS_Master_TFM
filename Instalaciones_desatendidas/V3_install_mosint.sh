#!/bin/bash

# Actualiza los paquetes
if [ "$(id -u)" -eq 0 ]; then
    # Si se está ejecutando como root
    apt update
else
    # Si se está ejecutando como usuario normal
    sudo apt update
fi

# Verifica e instala Go si es necesario
if command -v go &>/dev/null; then
    go version
else
    if [ "$(id -u)" -eq 0 ]; then
        # Instalación como root
        apt install -y golang-go
    else
        # Instalación como usuario normal con sudo
        sudo apt install -y golang-go
    fi
fi

# Verifica e instala Python3 y pip si es necesario
if command -v python3 &>/dev/null; then
    python3 --version
else
    if [ "$(id -u)" -eq 0 ]; then
        # Instalación como root
        apt install -y python3 python3-pip
    else
        # Instalación como usuario normal con sudo
        sudo apt install -y python3 python3-pip
    fi
fi

# Establece el directorio de trabajo
if [ "$(id -u)" -eq 0 ]; then
    # Si es root, usar el directorio home del usuario
    TARGET_DIR="/home/$SUDO_USER/Escritorio/Mosint"
else
    # Si es usuario normal, usar el directorio home del usuario
    TARGET_DIR="$HOME/Escritorio/Mosint"
fi

# Crea el directorio y navega a él
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

# Clona el repositorio de Mosint
git clone https://github.com/alpkeskin/mosint

# Navega al directorio del proyecto
cd mosint/v3/cmd/mosint

# Ejecuta el comando para verificar si funciona
go run main.go -h &>/dev/null
