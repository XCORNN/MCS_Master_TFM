#!/bin/bash

# Evitar que sudo pida contraseña durante la ejecución del script
sudo -v || exit 1  # Verifica que se tiene acceso sudo y solicita la contraseña una vez si es necesario
( sudo -n true ) 2>/dev/null || ( echo "Se requiere acceso sudo sin contraseña" && exit 1 )

# Actualizar el timestamp para evitar la solicitud de contraseña
sudo -v

# Continuamente actualizar el timestamp de sudo cada minuto para evitar que expire durante la ejecución del script
while true; do
    sudo -n true;
    sleep 60;
    kill -0 "$$" || exit;
done 2>/dev/null &

# Obtener el directorio del script
SCRIPT_DIR="$(dirname "$(realpath "$0")")/.."

# 1. Actualizar el sistema (requiere privilegios de administrador)
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Instalar la extensión de escritorio en el contexto del usuario
echo "Instalando la extensión de escritorio..."
depriv sudo apt install gnome-shell-extension-desktop-icons-ng -y

# 3. Crear directorios en el contexto del usuario
USER_HOME=$(eval echo "~$SUDO_USER")
DESKTOP_DIR="$USER_HOME/Escritorio"
mkdir -p "$DESKTOP_DIR"

# 4. Crear una carpeta de prueba en el contexto del usuario
TEST_DIR="$DESKTOP_DIR/CarpetaDePrueba"
mkdir -p "$TEST_DIR"

# 5. Configurar el archivo .desktop para el autoarranque en el contexto del usuario
AUTOSTART_DIR="$USER_HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

AUTOSTART_FILE="$AUTOSTART_DIR/habilitar_extension.desktop"
cat <<EOF > "$AUTOSTART_FILE"
[Desktop Entry]
Type=Application
Exec=$USER_HOME/habilitar_extension.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Habilitar Extensión de Escritorio
Comment=Habilita las extensiones de GNOME al iniciar sesión
EOF

# Asegurarse de que el archivo .desktop tenga los permisos correctos
chmod 644 "$AUTOSTART_FILE"

# 6. Crear el script de habilitación de extensión en el contexto del usuario
SCRIPT_FILE="$USER_HOME/habilitar_extension.sh"
cat <<EOF > "$SCRIPT_FILE"
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
EOF

# Hacer el script ejecutable
chmod +x "$SCRIPT_FILE"

# 7. Copiar el archivo gnome-applications.menu (no se requiere sudo, ya que no se menciona en tu solicitud)
# Si es necesario, agregar sudo aquí para las operaciones que lo requieran, pero no está en tu solicitud actual.

# 8. Crear el archivo .directory (no se requiere sudo, ya que no se menciona en tu solicitud)
# Si es necesario, agregar sudo aquí para las operaciones que lo requieran, pero no está en tu solicitud actual.

# 9. Reiniciar GNOME Shell para aplicar los cambios en el contexto del usuario
echo "Reiniciando GNOME Shell para aplicar los cambios..."
gnome-session-quit --logout --no-prompt
