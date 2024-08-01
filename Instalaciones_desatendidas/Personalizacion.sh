#!/bin/bash

# Fase 1: Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update && sudo apt upgrade -y

# Fase 2: Instalar la extensión de escritorio
echo "Instalando la extensión de escritorio..."
sudo apt install gnome-shell-extension-desktop-icons-ng -y

# Fase 3: Crear directorios
DESKTOP_DIR="$HOME/Escritorio"
mkdir -p "$DESKTOP_DIR"

# Fase 4: Crear una carpeta de prueba en el escritorio
TEST_DIR="$DESKTOP_DIR/CarpetaDePrueba"
mkdir -p "$TEST_DIR"

# Fase 5: Crear el script de inicio
cat << 'EOF' > /home/$USER/habilitar_extension.sh
#!/bin/bash

# Esperar a que GNOME Shell esté activo
echo "Esperando a que GNOME Shell se reinicie..."
while ! pgrep -u $USER gnome-shell > /dev/null; do sleep 1; done

# Comprobar el estado de la extensión
echo "Verificando el estado de la extensión..."
if gnome-extensions list | grep -q 'ding@rastersoft.com'; then
    echo "La extensión de escritorio está instalada."
else
    echo "La extensión de escritorio no está instalada. Instalando..."
    gnome-extensions install ding@rastersoft.com
fi

# Habilitar la extensión si no está habilitada
echo "Habilitando la extensión de escritorio..."
gnome-extensions enable ding@rastersoft.com

# Verificar que la extensión está habilitada
if gnome-extensions list | grep -q 'ding@rastersoft.com'; then
    echo "La extensión de escritorio ha sido habilitada."
else
    echo "No se pudo habilitar la extensión de escritorio."
fi
EOF

# Hacer el script ejecutable
chmod +x /home/$USER/habilitar_extension.sh

# Fase 6: Crear el archivo de arranque para ejecutar el script al inicio de sesión
mkdir -p /home/$USER/.config/autostart
cat << 'EOF' > /home/$USER/.config/autostart/habilitar_extension.desktop
[Desktop Entry]
Type=Application
Exec=/home/$USER/habilitar_extension.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Habilitar Extensión de Escritorio
Comment=Habilita la extensión de íconos en el escritorio al iniciar sesión
EOF

# Fase 7: Cerrar la sesión del usuario para aplicar los cambios
echo "Cerrando la sesión para aplicar los cambios..."
gnome-session-quit --logout --no-prompt

echo "La extensión ha sido instalada. La sesión se cerrará para aplicar los cambios. Al iniciar sesión nuevamente, se verificará y habilitará la extensión de escritorio."
