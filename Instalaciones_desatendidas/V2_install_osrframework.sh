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

# Definir la ruta del entorno virtual
DEST_DIR="/home/$SUDO_USER/Escritorio/osrframework-venv"

# Instalar paquetes necesarios
depriv bash -c "sudo apt install -y python3 python3-pip python3-venv"

# Crea el directorio de destino si no existe
depriv bash -c "
if [ ! -d '$DEST_DIR' ]; then
    echo 'Creando el directorio $DEST_DIR...'
    mkdir -p '$DEST_DIR'
    if [ \$? -ne 0 ]; then
        echo 'Error al crear el directorio $DEST_DIR. Verifica los permisos.'
        exit 1
    fi
else
    echo 'El directorio $DEST_DIR ya existe.'
fi
"

# Navega al directorio de destino y configura el entorno virtual
depriv bash -c "
cd '$DEST_DIR' || { echo 'No se pudo cambiar al directorio $DEST_DIR.'; exit 1; }

# Crea un entorno virtual para Python
python3 -m venv venv

# Verifica que el entorno virtual se ha creado correctamente
if [ ! -f 'venv/bin/activate' ]; then
    echo 'Error: No se pudo crear el entorno virtual. Verifica la instalación de python3-venv.'
    exit 1
fi

# Instala los paquetes necesarios
venv/bin/pip install osrframework
venv/bin/pip install urllib3==1.26.15
venv/bin/pip install --upgrade cfscrape
venv/bin/pip install --upgrade osrframework
"

# Mensaje de finalización y uso
echo "Instalación completada."
echo ""
echo "Para activar el entorno virtual y utilizar la aplicación, sigue estos pasos:"
echo ""
echo "1. Abre una terminal."
echo "2. Navega al directorio donde se creó el entorno virtual:"
echo "   cd /home/$SUDO_USER/Escritorio/osrframework-venv"
echo "3. Activa el entorno virtual con el siguiente comando:"
echo "   source venv/bin/activate"
echo ""
echo "4. Una vez activado, puedes ejecutar la aplicación o trabajar con los paquetes instalados."
echo "   Para probar la instalación, puedes usar los siguientes comandos, tal como se muestra en la documentación oficial:"
echo "   - \`usufy.py -n i3visio febrezo yrubiosec -p twitter facebook\`"
echo "   - \`searchfy.py -q \"i3visio\"\`"
echo "   - \`mailfy.py -n i3visio\`"
echo ""
echo "5. Puedes consultar la documentación oficial en https://github.com/i3visio/osrframework"
echo ""
echo "6. Para desactivar el entorno virtual, simplemente usa el comando:"
echo "   deactivate"
echo ""
echo "Recuerda que debes activar el entorno virtual cada vez que desees trabajar con la aplicación."
