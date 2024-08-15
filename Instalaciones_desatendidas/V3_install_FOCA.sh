#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verify 64-bit architecture
echo "Verifying 64-bit architecture..."
ARCHITECTURE=$(dpkg --print-architecture)
echo "Architecture: $ARCHITECTURE"

if [ "$ARCHITECTURE" != "amd64" ]; then
    echo "Error: This script is intended for 64-bit (amd64) architecture."
    exit 1
fi

# See if 32-bit architecture is already installed
echo "Checking for 32-bit architecture support..."
FOREIGN_ARCH=$(dpkg --print-foreign-architectures)
echo "Foreign architectures: $FOREIGN_ARCH"

# If it does not display "i386", add the architecture
if ! echo "$FOREIGN_ARCH" | grep -q "i386"; then
    echo "Adding i386 architecture..."
    sudo dpkg --add-architecture i386
fi

# Add the contrib repository
echo "Adding contrib repository..."
sudo tee -a /etc/apt/sources.list.d/contrib.list > /dev/null <<EOL
deb http://deb.debian.org/debian bullseye main contrib non-free
EOL

# Download and add the WineHQ repository key
echo "Adding WineHQ repository key..."
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

# Add the Wine repository
echo "Adding Wine repository..."
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources

# Update repositories
echo "Updating package lists..."
sudo apt update

# Descargar e instalar silenciosamente wine-mono 8.1.0 en el cache del usuario
echo "Ensuring silent installation of wine-mono 8.1.0..."
depriv bash -c "mkdir -p /home/$SUDO_USER/.cache/wine/ && \
wget -O /home/$SUDO_USER/.cache/wine/wine-mono-8.1.0-x86.msi https://dl.winehq.org/wine/wine-mono/8.1.0/wine-mono-8.1.0-x86.msi"

# Install WINE
echo "Installing WINE..."
sudo apt install --install-recommends -y winehq-stable

# Install Winetricks
echo "Installing Winetricks..."
sudo apt install -y winetricks

# Install additional components using Winetricks
echo "Installing additional components with Winetricks..."
depriv winetricks -q dotnet48 gdiplus fontfix

# Crear carpeta FOCA en el Escritorio
depriv mkdir -p "/home/$SUDO_USER/Escritorio/Foca"

# Moverse a la carpeta creada
depriv bash -c "cd /home/$SUDO_USER/Escritorio/Foca && \
#Importar Foca de Github
wget https://github.com/ElevenPaths/FOCA/releases/download/v3.4.7.1/FOCA-v3.4.7.1.zip && \
#Descomprimir Foca.zip
unzip -d . FOCA-v3.4.7.1.zip && \
#Borrar comprimido
rm FOCA-v3.4.7.1.zip"

echo "All tasks completed successfully."

# Arranque en carpeta con:
#   wine Foca.exe
# Se conecta con los siguientes datos de conexion:
#   localhost / SA / Passw0rd!
