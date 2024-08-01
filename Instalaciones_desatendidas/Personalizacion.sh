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

# Fase 5: Crear el script de inicio simplificado
cat << 'EOF' > /home/$USER/habilitar_extension.sh
#!/bin/bash

# Esperar a que GNOME Shell esté activo
sleep 10

# Habilitar la extensión de escritorio
gnome-extensions enable ding@rastersoft.com
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

echo "La extensión ha sido instalada. La sesión se cerrará para aplicar los cambios. Al iniciar sesión nuevamente, el script de inicio habilitará la extensión de escritorio."

