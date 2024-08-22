#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verificar la arquitectura de 64 bits
echo "Verificando arquitectura de 64 bits..."
ARQUITECTURA=$(dpkg --print-architecture)
echo "Arquitectura: $ARQUITECTURA"

if [ "$ARQUITECTURA" != "amd64" ]; then
    echo "Error: Este script está diseñado para la arquitectura de 64 bits (amd64)."
    exit 1
fi

# Verificar si la arquitectura de 32 bits ya está instalada
echo "Verificando soporte para arquitectura de 32 bits..."
ARQUITECTURA_EXTRANJERA=$(dpkg --print-foreign-architectures)
echo "Arquitecturas extranjeras: $ARQUITECTURA_EXTRANJERA"

# Si no muestra "i386", agregar la arquitectura
if ! echo "$ARQUITECTURA_EXTRANJERA" | grep -q "i386"; then
    echo "Agregando la arquitectura i386..."
    sudo dpkg --add-architecture i386
fi

# Agregar el repositorio contrib
echo "Agregando repositorio contrib..."
sudo tee -a /etc/apt/sources.list.d/contrib.list > /dev/null <<EOL
deb http://deb.debian.org/debian bullseye main contrib non-free
EOL

# Descargar y agregar la clave del repositorio de WineHQ
echo "Agregando clave del repositorio de WineHQ..."
sudo mkdir -pm755 /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

# Agregar el repositorio de Wine
echo "Agregando repositorio de Wine..."
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources

# Actualizar los repositorios
echo "Actualizando listas de paquetes..."
sudo apt update

# Descargar e instalar silenciosamente wine-mono 8.1.0 en la caché del usuario
echo "Asegurando la instalación silenciosa de wine-mono 8.1.0..."
depriv bash -c "mkdir -p /home/$SUDO_USER/.cache/wine/ && \
wget -O /home/$SUDO_USER/.cache/wine/wine-mono-8.1.0-x86.msi https://dl.winehq.org/wine/wine-mono/8.1.0/wine-mono-8.1.0-x86.msi"

# Instalar WINE
echo "Instalando WINE..."
sudo apt install --install-recommends -y winehq-stable

# Instalar Winetricks
echo "Instalando Winetricks..."
sudo apt install -y winetricks

# Instalar componentes adicionales usando Winetricks
echo "Instalando componentes adicionales con Winetricks..."
depriv winetricks -q dotnet48 gdiplus fontfix

# Crear carpeta FOCA en el Escritorio
depriv mkdir -p "/home/$SUDO_USER/Escritorio/Foca"

# Moverse a la carpeta creada
depriv bash -c "cd /home/$SUDO_USER/Escritorio/Foca && \
# Importar FOCA de Github
wget https://github.com/ElevenPaths/FOCA/releases/download/v3.4.7.1/FOCA-v3.4.7.1.zip && \
# Descomprimir FOCA.zip
unzip -d . FOCA-v3.4.7.1.zip && \
# Borrar archivo comprimido
rm FOCA-v3.4.7.1.zip"

echo "Todas las tareas se completaron con éxito."

# Arrancar en la carpeta con:
#   wine Foca.exe
# Se conecta con los siguientes datos de conexión:
#   localhost / SA / Passw0rd!
