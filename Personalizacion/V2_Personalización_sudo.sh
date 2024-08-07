#!/bin/bash

# Verificar si el script se está ejecutando como superusuario
if [ "$(id -u)" -ne "0" ]; then
    echo "Este script debe ser ejecutado con sudo."
    exit 1
fi

# 1. Actualizar el sistema
echo "Actualizando el sistema..."
apt update && apt upgrade -y

# 2. Instalar la extensión de escritorio
echo "Instalando la extensión de escritorio..."
apt install gnome-shell-extension-desktop-icons-ng -y

# Variables del usuario que ejecutó el script
USER_HOME=$(eval echo ~$SUDO_USER)  # Obtener el home del usuario que invocó sudo
USER_NAME=$SUDO_USER

# 3. Crear directorios y archivos específicos del usuario
echo "Configurando el entorno del usuario..."

# Crear directorios en el directorio del usuario
DESKTOP_DIR="$USER_HOME/Escritorio"
mkdir -p "$DESKTOP_DIR"

# Crear una carpeta de prueba
TEST_DIR="$DESKTOP_DIR/CarpetaDePrueba"
mkdir -p "$TEST_DIR"

# Configurar el archivo .desktop para el autoarranque
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
Comment=Habilita la extensión de íconos en el escritorio al iniciar sesión
EOF

# Asegurarse de que el archivo .desktop tenga los permisos correctos
chmod 644 "$AUTOSTART_FILE"

# Crear el script de habilitación de extensión
SCRIPT_FILE="$USER_HOME/habilitar_extension.sh"
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

# 4. Cierre de sesión
echo "Reiniciando GNOME Shell para aplicar los cambios..."
# Nota: Ejecutar esto como usuario para reiniciar GNOME Shell
sudo -u "$USER_NAME" gnome-session-quit --logout --no-prompt
