#!/bin/bash

# Archivo de log para depuración
LOG_DIR="$HOME/Escritorio"
LOG_FILE="$LOG_DIR/habilitar_extension.log"

# Función para registrar mensajes en el archivo de log
log_message() {
    echo "$(date): $1" >> "$LOG_FILE"
}

# Comenzar el registro
log_message "Inicio del script de configuración."

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
log_message "Configurando el archivo .desktop para el autoarranque..."

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
log_message "Archivo .desktop configurado correctamente."

# 6. Crear el script de habilitación de extensión
SCRIPT_FILE="$HOME/habilitar_extension.sh"
log_message "Creando el script de habilitación de extensión..."

cat <<EOF > "$SCRIPT_FILE"
#!/bin/bash

# Archivo de log para depuración
LOG_FILE="$HOME/Escritorio/habilitar_extension.log"

# Función para registrar mensajes en el archivo de log
log_message() {
    echo "\$(date): \$1" >> "\$LOG_FILE"
}

# Crear el directorio de log si no existe
mkdir -p "\$HOME/Escritorio"

# Comenzar el registro
log_message "Inicio del script de habilitación de extensión."

# Verificar si el script tiene permisos de ejecución
if [ ! -x "\$HOME/habilitar_extension.sh" ]; then
    log_message "Error: El script no tiene permisos de ejecución."
    exit 1
fi

# Verificar permisos del directorio de logs
if [ ! -w "\$HOME/Escritorio" ]; then
    log_message "Error: El directorio de logs (\$HOME/Escritorio) no tiene permisos de escritura."
    exit 1
fi

# Esperar 2 segundos para que GNOME Shell esté activo
log_message "Esperando 2 segundos para que GNOME Shell esté activo..."
sleep 2

# Intentar habilitar la extensión de escritorio
log_message "Intentando habilitar la extensión de escritorio..."
gnome-extensions enable ding@rastersoft.com >> "\$LOG_FILE" 2>&1

# Verificar si la extensión está habilitada
if gnome-extensions list | grep -q 'ding@rastersoft.com'; then
    log_message "La extensión de escritorio ha sido habilitada correctamente."
else
    log_message "No se pudo habilitar la extensión de escritorio."
fi

# Finalizar el registro
log_message "Fin del script de habilitación de extensión."
EOF

# Hacer el script ejecutable
chmod +x "$SCRIPT_FILE"
log_message "Script de habilitación de extensión creado y configurado."

# 7. Cierre de sesión
echo "Reiniciando GNOME Shell para aplicar los cambios..."
gnome-session-quit --logout --no-prompt

# Finalizar el registro
log_message "Fin del script de configuración."

