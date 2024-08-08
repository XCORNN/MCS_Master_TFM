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

# Instala dependencias necesarias incluyendo python3-venv
sudo apt install -y git python3 python3-pip python3-venv

# Crea el directorio Photon en el Escritorio
depriv bash -c "mkdir -p /home/$SUDO_USER/Escritorio/Photon"

# Cambia al directorio Photon en el Escritorio y realiza las operaciones necesarias
depriv bash -c "
cd /home/$SUDO_USER/Escritorio/Photon || { echo 'No se pudo cambiar al directorio /home/$SUDO_USER/Escritorio/Photon.'; exit 1; }
# Clona el repositorio Photon de GitHub
git clone https://github.com/s0md3v/Photon.git
if [ $? -ne 0 ]; then
    echo 'Error al clonar el repositorio de Photon. Verifica la conexión a Internet y los permisos.'
    exit 1
fi
# Mueve el contenido de Photon/Photon a Photon
mv Photon/* .

# Crea un entorno virtual y activa el entorno virtual
depriv bash -c "
cd /home/$SUDO_USER/Escritorio/Photon || { echo 'No se pudo cambiar al directorio /home/$SUDO_USER/Escritorio/Photon.'; exit 1; }
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo 'Error al crear el entorno virtual. Verifica que el paquete python3-venv esté instalado.'
    exit 1
fi
source venv/bin/activate
"

# Instala las dependencias dentro del entorno virtual
depriv bash -c "
cd /home/$SUDO_USER/Escritorio/Photon || { echo 'No se pudo cambiar al directorio /home/$SUDO_USER/Escritorio/Photon.'; exit 1; }
source venv/bin/activate
pip install tld requests
"

# Confirmación de instalación y comando para usar Photon
depriv bash -c "
echo 'Photon ha sido instalado correctamente en /home/$SUDO_USER/Escritorio/Photon'
echo 'Para ejecutar Photon, usa el siguiente comando:'
echo 'source /home/$SUDO_USER/Escritorio/Photon/venv/bin/activate && python3 /home/$SUDO_USER/Escritorio/Photon/photon.py'
"

# Elimina la carpeta Photon/Photon si aún existe
depriv bash -c "
rm -rf /home/$SUDO_USER/Escritorio/Photon/Photon
"
