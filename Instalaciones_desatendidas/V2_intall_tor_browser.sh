#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Directorio de instalación del Tor Browser
TOR_BROWSER_DIR="$HOME/Escritorio/Tor"

# URL del paquete del Tor Browser y su firma
TOR_BROWSER_URL="https://www.torproject.org/dist/torbrowser/13.5.1/tor-browser-linux-x86_64-13.5.1.tar.xz"
TOR_BROWSER_SIG_URL="https://www.torproject.org/dist/torbrowser/13.5.1/tor-browser-linux-x86_64-13.5.1.tar.xz.asc"
TOR_GPG_KEY_URL="https://keys.openpgp.org/vks/v1/by-fingerprint/EF6E286DDA85EA2A4BA7DE684E2C6E8793298290"

# Nombre del archivo descargado
TOR_BROWSER_TAR="tor-browser-linux-x86_64-13.5.1.tar.xz"
TOR_BROWSER_SIG="tor-browser-linux-x86_64-13.5.1.tar.xz.asc"
TOR_GPG_KEY="torproject-key.asc"

# Verifica si wget y gpg están instalados, si no lo están, lo instala
if ! command -v wget &> /dev/null || ! command -v gpg &> /dev/null; then
    echo "wget o gpg no están instalados. Instalando..."
    sudo apt update
    sudo apt install -y wget gnupg
fi

# Crear carpeta Tor en el Escritorio
depriv bash -c "
mkdir -p '$TOR_BROWSER_DIR'
"

# Moverse a la carpeta creada
cd "$TOR_BROWSER_DIR" || { echo "No se pudo cambiar al directorio $TOR_BROWSER_DIR."; exit 1; }

# Descargar el archivo de Tor Browser y su firma
echo "Descargando Tor Browser y su firma..."
wget -O "$TOR_BROWSER_TAR" "$TOR_BROWSER_URL"
wget -O "$TOR_BROWSER_SIG" "$TOR_BROWSER_SIG_URL"

# Descargar la clave pública de GPG
echo "Descargando la clave pública de GPG..."
wget -O "$TOR_GPG_KEY" "$TOR_GPG_KEY_URL"

# Importar la clave pública de GPG
echo "Importando la clave pública de GPG..."
gpg --import "$TOR_GPG_KEY"

# Verificar la firma del paquete
echo "Verificando la firma del paquete..."
gpg --verify "$TOR_BROWSER_SIG" "$TOR_BROWSER_TAR"
if [ $? -ne 0 ]; then
    echo "La verificación de la firma GPG ha fallado. Abortando la instalación."
    exit 1
fi

# Descomprimir el archivo descargado
echo "Extrayendo Tor Browser..."
tar -xvf "$TOR_BROWSER_TAR"

# Borrar el archivo comprimido descargado
rm "$TOR_BROWSER_TAR" "$TOR_BROWSER_SIG" "$TOR_GPG_KEY"

echo "Tor Browser ha sido instalado correctamente en $TOR_BROWSER_DIR."

# Mensaje informativo para el usuario sobre cómo ejecutar Tor Browser
echo "Para ejecutar Tor Browser, dirígete a la carpeta $TOR_BROWSER_DIR/tor-browser y ejecuta ./start-tor-browser"
