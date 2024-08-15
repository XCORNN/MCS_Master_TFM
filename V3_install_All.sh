#!/bin/bash

# Define la URL base del repositorio de GitHub
REPO_URL="https://github.com/XCORNN/MCS_Master_TFM"

# Lista de scripts a ejecutar en Instalaciones_desatendidas
INSTALL_SCRIPTS=(
    "V2_install_Harvester.sh"
    "V2_install_Maltego.sh"
    "V2_install_exiftool.sh"
    "V2_install_Photon.sh"
    "V2_install_Spiderfoot.sh"
    "V2_install_sublist3r.sh"
    "V2_install_GooHak.sh"
    "V2_install_tor_service.sh"
    "V2_install_tor_browser.sh"
    "V2_install_Recon_NG.sh"
    "V2_install_sslscan.sh"
    "V2_install_dmitry.sh"
    "V2_install_sherlock.sh"
    "V2_install_burpsuite.sh"
    "V2_install_mosint.sh"
    "V2_install_osrframework.sh"
    "V2_install_FOCA.sh"
    "V2_Foca_sqlExpress.sh"
)

# Función para verificar si el script se ejecutó correctamente
check_success() {
    if [ $? -eq 0 ]; then
        echo "$1 se ejecutó correctamente."
    else
        echo "Error al ejecutar $1."
        exit 1
    fi
}

# Función para clonar el repositorio
clone_repo() {
    echo "Clonando el repositorio..."
    git clone "$REPO_URL"
    check_success "git clone"
}

# Función para instalar zenity si no está instalado
install_zenity() {
    if ! command -v zenity > /dev/null; then
        echo "Zenity no está instalado. Instalando zenity..."
        sudo apt-get update && sudo apt-get install -y zenity
        check_success "instalación de zenity"
    fi
}

# Verificar si estamos dentro de MCS_Master_TFM y si existe Instalaciones_desatendidas
if [ -d "Instalaciones_desatendidas" ]; then
    echo "Ya estás dentro del directorio del repositorio."
else
    # Navegar hacia arriba para ver si estamos en un subdirectorio
    cd .. || { echo "Error al navegar hacia arriba"; exit 1; }
    
    if [ -d "MCS_Master_TFM" ]; then
        echo "Navegando al directorio del repositorio."
        cd MCS_Master_TFM || { echo "Error al cambiar al directorio MCS_Master_TFM"; exit 1; }
    else
        # Si no estamos en un subdirectorio del repositorio, clonar el repositorio
        clone_repo
        cd MCS_Master_TFM || { echo "Error al cambiar al directorio MCS_Master_TFM"; exit 1; }
    fi
    
    # Verificar nuevamente si existe Instalaciones_desatendidas
    if [ ! -d "Instalaciones_desatendidas" ]; then
        echo "No se encontró Instalaciones_desatendidas después de clonar."
        exit 1
    fi
fi

# Navegar al directorio que contiene los scripts de instalación
cd Instalaciones_desatendidas || { echo "Error al cambiar al directorio Instalaciones_desatendidas"; exit 1; }

# Hacer que todos los scripts sean ejecutables
echo "Estableciendo permisos de ejecución para todos los scripts..."
chmod +x *.sh
check_success "chmod +x *.sh"

# Ejecutar cada script en la secuencia
for script in "${INSTALL_SCRIPTS[@]}"; do
    echo "Ejecutando $script..."
    bash "./$script"
    check_success "$script"
done

echo "Todos los scripts de Instalaciones_desatendidas se ejecutaron correctamente."

# Regresar al directorio raíz del repositorio para ejecutar Personalizacion.sh
cd .. || { echo "Error al navegar al directorio padre"; exit 1; }
cd Personalizacion || { echo "Error al cambiar al directorio Personalizacion"; exit 1; }

# Verificar si V2_Personalizacion.sh existe y es ejecutable
if [ -f "V2_Personalizacion.sh" ]; then
    # Asegurarse de que V2_Personalizacion.sh sea ejecutable
    chmod +x V2_Personalizacion.sh

    # Ejecutar el script adicional
    echo "Ejecutando V2_Personalizacion.sh..."
    bash "./V2_Personalizacion.sh"
    check_success "V2_Personalizacion.sh"
    
    echo "V2_Personalizacion.sh se ejecutó correctamente."
else
    echo "No se encontró V2_Personalizacion.sh en el directorio Personalizacion."
    exit 1
fi

# Instalar zenity si no está instalado
install_zenity

# Mostrar una notificación para reiniciar el sistema
if zenity --question --title="Reinicio Requerido" --text="Necesitas reiniciar el sistema para aplicar los cambios. ¿Deseas reiniciar ahora?" --ok-label="Reiniciar" --cancel-label="Cancelar"; then
    echo "Reiniciando el sistema..."
    sudo reboot
else
    echo "Reinicio cancelado. Por favor, reinicie el sistema manualmente para aplicar los cambios."
fi

echo "Notificación de reinicio mostrada."
