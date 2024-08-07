#!/bin/bash

# Función para ejecutar comandos en el contexto del usuario que invocó el script
depriv() {
  if [[ $SUDO_USER ]]; then
    sudo -u "$SUDO_USER" -- "$@"
  else
    "$@"
  fi
}

# Obtener el directorio del script
SCRIPT_DIR="$(dirname "$(realpath "$0")")/.."

# 1. Actualizar el sistema (requiere privilegios de administrador)
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Instalar la extensión de escritorio (requiere privilegios de administrador)
echo "Instalando la extensión de escritorio..."
sudo apt install gnome-shell-extension-desktop-icons-ng -y

# 3. Crear directorios en el contexto del usuario
DESKTOP_DIR="$HOME/Escritorio"
depriv mkdir -p "$DESKTOP_DIR"

# 4. Crear una carpeta de prueba en el contexto del usuario
TEST_DIR="$DESKTOP_DIR/CarpetaDePrueba"
depriv mkdir -p "$TEST_DIR"

# 5. Configurar el archivo .desktop para el autoarranque en el contexto del usuario
AUTOSTART_DIR="$HOME/.config/autostart"
depriv mkdir -p "$AUTOSTART_DIR"

AUTOSTART_FILE="$AUTOSTART_DIR/habilitar_extension.desktop"
depriv bash -c "cat <<EOF > \"$AUTOSTART_FILE\"
[Desktop Entry]
Type=Application
Exec=$HOME/habilitar_extension.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Habilitar Extensión de Escritorio
Comment=Habilita las extensiones de GNOME al iniciar sesión
EOF"

# Asegurarse de que el archivo .desktop tenga los permisos correctos en el contexto del usuario
depriv chmod 644 "$AUTOSTART_FILE"

# 6. Crear el script de habilitación de extensión en el contexto del usuario
SCRIPT_FILE="$HOME/habilitar_extension.sh"
depriv bash -c "cat <<EOF > \"$SCRIPT_FILE\"
#!/bin/bash

# Esperar 2 segundos para que GNOME Shell esté activo
sleep 2

# Intentar habilitar la extensión de íconos en el escritorio
gnome-extensions enable ding@rastersoft.com

# Intentar habilitar la extensión de menú de aplicaciones
gnome-extensions enable apps-menu@gnome-shell-extensions.gcampax.github.com

# Verificar si la extensión de íconos en el escritorio está habilitada
if gnome-extensions list | grep -q 'ding@rastersoft.com'; then
    echo "La extensión de íconos en el escritorio ha sido habilitada correctamente."
else
    echo "No se pudo habilitar la extensión de íconos en el escritorio."
fi

# Verificar si la extensión de menú de aplicaciones está habilitada
if gnome-extensions list | grep -q 'apps-menu@gnome-shell-extensions.gcampax.github.com'; then
    echo "La extensión de menú de aplicaciones ha sido habilitada correctamente."
else
    echo "No se pudo habilitar la extensión de menú de aplicaciones."
fi
EOF"

# Hacer el script ejecutable en el contexto del usuario
depriv chmod +x "$SCRIPT_FILE"

# 7. Copiar el archivo gnome-applications.menu a /etc/xdg/menus/ (requiere privilegios de administrador)
echo "Copiando gnome-applications.menu..."
sudo cp -p "$SCRIPT_DIR/Files/gnome-applications.menu" /etc/xdg/menus/gnome-applications.menu

# Ajustar permisos y propiedad del archivo gnome-applications.menu (requiere privilegios de administrador)
echo "Ajustando permisos y propiedad del archivo gnome-applications.menu..."
sudo chmod 644 /etc/xdg/menus/gnome-applications.menu
sudo chown root:root /etc/xdg/menus/gnome-applications.menu

# 8. Crear el archivo .directory en /usr/share/desktop-directories (requiere privilegios de administrador)
echo "Creando el archivo .directory..."
sudo bash -c 'cat <<EOF > /usr/share/desktop-directories/information-gathering-tools.directory
[Desktop Entry]
Name=Information Gathering Tools
Comment=Herramientas para recopilación de información pública
Type=Directory
EOF
chmod 644 /usr/share/desktop-directories/information-gathering-tools.directory'

# 9. Reiniciar GNOME Shell para aplicar los cambios en el contexto del usuario
echo "Reiniciando GNOME Shell para aplicar los cambios..."
depriv gnome-session-quit --logout --no-prompt
