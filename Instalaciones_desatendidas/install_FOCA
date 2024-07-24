#!/bin/bash

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

# Install WINE
echo "Installing WINE..."
sudo apt install --install-recommends -y winehq-stable

# Install Winetricks
echo "Installing Winetricks..."
sudo apt install -y winetricks

# Install additional components using Winetricks
echo "Installing additional components with Winetricks..."
winetricks -q dotnet48 gdiplus fontfix

# Install wine-mono
#echo "Installing wine-mono..."
#sudo apt install -y wine-mono

# Crear carpeta FOCA en el Escritorio
mkdir -p "$HOME/Escritorio/Foca"

# Moverse a la carpeta creada
cd "$HOME/Escritorio/Foca"

#Importar Foca de Github
wget https://github.com/ElevenPaths/FOCA/releases/download/v3.4.7.1/FOCA-v3.4.7.1.zip

#Descomprimir Foca.zip
unzip -d . FOCA-v3.4.7.1.zip

#Borrar compimido
rm FOCA-v3.4.7.1.zip 


echo "All tasks completed successfully."

