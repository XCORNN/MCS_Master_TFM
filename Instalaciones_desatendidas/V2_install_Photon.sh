#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Crear carpeta Photon en el Escritorio
depriv mkdir -p /home/$SUDO_USER/Escritorio/Photon

# Cambiar al directorio Photon en el Escritorio
depriv bash -c "cd /home/$SUDO_USER/Escritorio/Photon && \
# Clonar el repositorio Photon de GitHub
git clone https://github.com/s0md3v/Photon.git && \
# Mover el contenido de Photon/Photon a Photon
mv Photon/* . && \
# Eliminar la carpeta Photon vacía
rmdir Photon"

# Verificar si pip3 está instalado, de lo contrario, instalar pip3 y los paquetes necesarios
if depriv which pip3 &> /dev/null; then
  depriv pip3 install tld requests --break-system-packages
else
  sudo apt install -y python3-pip
  depriv pip3 install tld requests --break-system-packages
fi
