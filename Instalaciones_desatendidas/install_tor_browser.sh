#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Verifica si el script se está ejecutando como root
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script debe ejecutarse como root"
    exit 1
fi

# Directorio de instalación del Tor Browser
TOR_BROWSER_DIR="/home/$SUDO_USER/Escritorio/Tor"

# URL del paquete del Tor Browser y su firma
TOR_BROWSER_URL="https://www.torproject.org/dist/torbrowser/13.5.3/tor-browser-linux-x86_64-13.5.3.tar.xz"
TOR_BROWSER_SIG_URL="https://www.torproject.org/dist/torbrowser/13.5.3/tor-browser-linux-x86_64-13.5.3.tar.xz.asc"
TOR_GPG_KEY_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/EF6E286DDA85EA2A4BA7DE684E2C6E8793298290"

# Nombre del archivo descargado
TOR_BROWSER_TAR="tor-browser-linux-x86_64-13.5.3.tar.xz"
TOR_BROWSER_SIG="tor-browser-linux-x86_64-13.5.3.tar.xz.asc"
TOR_GPG_KEY="torproject-key.asc"

# Verifica si wget y gpg están instalados, si no lo están, lo instala
echo "Verificando la instalación de wget y gpg..."
if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null
then
    echo "wget o gpg no están instalados. Instalando..."
    sudo apt update
    sudo apt install -y wget gnupg
fi

# Crear carpeta Tor en el Escritorio del usuario
echo "Creando carpeta Tor en el Escritorio del usuario..."
depriv mkdir -p "$TOR_BROWSER_DIR"

# Moverse a la carpeta creada y descargar archivos
echo "Moviéndose a la carpeta $TOR_BROWSER_DIR..."
depriv bash -c "cd '$TOR_BROWSER_DIR' && echo 'Directorio actual:' && pwd && \
echo 'Descargando Tor Browser y su firma...' && \
wget -O '$TOR_BROWSER_TAR' '$TOR_BROWSER_URL' && \
wget -O '$TOR_BROWSER_SIG' '$TOR_BROWSER_SIG_URL' && \
echo 'Descargando la clave pública de GPG...' && \
wget -O '$TOR_GPG_KEY' '$TOR_GPG_KEY_URL'"

# Verificar la existencia de los archivos descargados
echo "Verificando la existencia de archivos..."
if [ ! -f "$TOR_BROWSER_DIR/$TOR_GPG_KEY" ]; then
    echo "Error: No se pudo encontrar la clave pública de GPG. Abortando la instalación."
    exit 1
fi

if [ ! -f "$TOR_BROWSER_DIR/$TOR_BROWSER_SIG" ]; then
    echo "Error: No se pudo encontrar la firma del paquete. Abortando la instalación."
    exit 1
fi

# Importar la clave pública de GPG
echo "Importando la clave pública de GPG..."
depriv gpg --import "$TOR_BROWSER_DIR/$TOR_GPG_KEY"

# Verificar la firma del paquete
echo "Verificando la firma del paquete..."
depriv gpg --verify "$TOR_BROWSER_DIR/$TOR_BROWSER_SIG" "$TOR_BROWSER_DIR/$TOR_BROWSER_TAR"
if [ $? -ne 0 ]; then
    echo "La verificación de la firma GPG ha fallado. Abortando la instalación."
    exit 1
fi

# Descomprimir el archivo descargado
echo "Extrayendo Tor Browser..."
depriv tar -xvf "$TOR_BROWSER_DIR/$TOR_BROWSER_TAR" -C "$TOR_BROWSER_DIR"

# Borrar el archivo comprimido descargado
echo "Borrando archivos descargados..."
depriv rm "$TOR_BROWSER_DIR/$TOR_BROWSER_TAR" "$TOR_BROWSER_DIR/$TOR_BROWSER_SIG" "$TOR_BROWSER_DIR/$TOR_GPG_KEY"

echo "Tor Browser ha sido instalado correctamente en $TOR_BROWSER_DIR."

# Mensaje informativo para el usuario sobre cómo ejecutar Tor Browser
echo "Para ejecutar Tor Browser, dirígete a la carpeta $TOR_BROWSER_DIR/tor-browser y ejecuta ./start-tor-browser"
