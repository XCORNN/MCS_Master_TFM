#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Función para verificar si el comando existe
command_exists() {
  command -v "$1" &> /dev/null
}

# Función para mostrar mensajes de error y salir del script
error_exit() {
  echo "$1" 1>&2
  exit 1
}

# Verificar la instalación de Python y pip
check_python_and_pip() {
  echo "Verificando Python y Pip..."

  # Verificar Python
  if ! command_exists python3; then
    echo "Python 3 no está instalado. Instalando Python 3..."
    depriv sudo apt update || error_exit "Error al actualizar la lista de paquetes."
    depriv sudo apt install -y python3 || error_exit "Error al instalar Python 3."
  else
    echo "Python 3 está instalado."
  fi

  # Verificar Pip
  if ! command_exists pip3; then
    echo "Pip no está instalado. Instalando Pip..."
    depriv sudo apt update || error_exit "Error al actualizar la lista de paquetes."
    depriv sudo apt install -y python3-pip || error_exit "Error al instalar Pip."
  else
    echo "Pip está instalado."
  fi

  # Verificar virtualenv
  if ! pip3 show virtualenv &> /dev/null; then
    echo "virtualenv no está instalado. Instalando virtualenv..."
    depriv pip3 install virtualenv --user || error_exit "Error al instalar virtualenv."
  else
    echo "virtualenv está instalado."
  fi
}

# Crear y activar el entorno virtual
create_and_activate_venv() {
  echo "Creando el entorno virtual en /home/$USER/Escritorio/osrframework/venv..."
  local base_dir="/home/$USER/Escritorio/osrframework"
  local venv_dir="$base_dir/venv"
  
  mkdir -p "$base_dir" || error_exit "Error al crear el directorio base."

  depriv virtualenv "$venv_dir" || error_exit "Error al crear el entorno virtual."
  source "$venv_dir/bin/activate" || error_exit "Error al activar el entorno virtual."
}

# Instalar osrframework dentro del entorno virtual
install_osrframework() {
  echo "Instalando osrframework dentro del entorno virtual..."
  pip install --upgrade pip || error_exit "Error al actualizar pip."
  pip install osrframework || error_exit "Error al instalar osrframework."
}

# Verificar la instalación
verify_installation() {
  echo "Verificando la instalación de osrframework..."
  if ! command_exists osrframework; then
    echo "osrframework no se encuentra en el PATH. Verificando la instalación..."
    local osrframework_path=$(find "$VENV_DIR/bin" -name "osrframework" 2> /dev/null)
    if [ -z "$osrframework_path" ]; then
      echo "No se encontró osrframework. Asegúrate de que el directorio '$VENV_DIR/bin' esté en tu PATH."
      echo "Puedes añadirlo con: export PATH=$VENV_DIR/bin:$PATH"
      exit 1
    else
      echo "osrframework se encuentra en $osrframework_path"
    fi
  else
    echo "osrframework está disponible en el PATH."
  fi
}

# Ejecutar comandos de prueba para verificar la funcionalidad
run_tests() {
  echo "Probando la ejecución de comandos..."
  if ! osrframework --help > /dev/null 2>&1; then
    echo "Error al ejecutar osrframework. Verifica la instalación y las dependencias."
    exit 1
  else
    echo "osrframework está funcionando correctamente."
  fi
}

# Variables globales
BASE_DIR="/home/$USER/Escritorio/osrframework"
VENV_DIR="$BASE_DIR/venv"

# Ejecutar los pasos
check_python_and_pip
create_and_activate_venv
install_osrframework
verify_installation
run_tests

echo "Instalación completada con éxito."
