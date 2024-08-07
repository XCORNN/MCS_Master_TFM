#!/bin/bash

# Función para cambiar al usuario que invocó sudo
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Obtener el directorio del script
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# 1. Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Instalar la extensión de escritorio
echo "Instalando la extensión de escritorio..."
sudo apt install gnome-shell-extension-desktop-icons-ng -y

# 3. Crear directorios
DESKTOP_DIR="$HOME/Escritorio"
mkdir -p "$DESKTOP_DIR"

# 4. Crear una carpeta de prueba
TEST_DIR="$DESKTOP_DIR/CarpetaDePrueba"
mkdir -p "$TEST_DIR"

# 5. Configurar el archivo .desktop para el autoarranque
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

AUTOSTART_FILE="$AUTOSTART_DIR/habilitar_extension.desktop"
cat <<EOF > "$AUTOSTART_FILE"
[Desktop Entry]
Type=Application
Exec=/home/$USER/habilitar_extension.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Habilitar Extensión de Escritorio
Comment=Habilita la extensión de íconos en el escritorio al iniciar sesión
EOF

# Asegurarse de que el archivo .desktop tenga los permisos correctos
chmod 644 "$AUTOSTART_FILE"

# 6. Crear el script de habilitación de extensión
SCRIPT_FILE="$HOME/habilitar_extension.sh"
cat <<EOF > "$SCRIPT_FILE"
#!/bin/bash

# Esperar 2 segundos para que GNOME Shell esté activo
sleep 2

# Intentar habilitar la extensión de escritorio
gnome-extensions enable ding@rastersoft.com

# Verificar si la extensión está habilitada
if gnome-extensions list | grep -q 'ding@rastersoft.com'; then
    echo "La extensión de escritorio ha sido habilitada correctamente."
else
    echo "No se pudo habilitar la extensión de escritorio."
fi
EOF

# Hacer el script ejecutable
chmod +x "$SCRIPT_FILE"

# 7. Copiar el archivo gnome-applications.menu a /etc/xdg/menus/
echo "Copiando gnome-applications.menu..."
sudo cp -p "$SCRIPT_DIR/Files/gnome-applications.menu" /etc/xdg/menus/gnome-applications.menu

# 8. Crear el archivo .directory en /usr/share/desktop-directories
echo "Creando el archivo .directory..."
sudo bash -c 'cat <<EOF > /usr/share/desktop-directories/information-gathering-tools.directory
[Desktop Entry]
Name=Information Gathering Tools
Comment=Herramientas para recopilación de información pública
Type=Directory
EOF
chmod 644 /usr/share/desktop-directories/information-gathering-tools.directory'

# 9. Cierre de sesión
echo "Reiniciando GNOME Shell para aplicar los cambios..."
gnome-session-quit --logout --no-prompt
