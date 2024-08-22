# MCS_Master_TFM

Este repositorio tiene como objetivo automatizar las descargas e instalaciones de ciertas herramientas de OSINT en un **Entorno Debian 12 limpio**, para realizar un despliegue rápido y seguro.

Mediante la descarga e instalación del repositorio obtienes los scripts de ejecución para crear todo el despliegue o tan solo las herramientas necesarias.

## Descripción
Herramientas de código abierto utilizadas para la recolección de correos electrónicos, nombres de usuarios, hosts y subdominios de diferentes fuentes públicas como motores de búsqueda y claves PGP.

## Pre-requisitos

Añadir el usuario principal **(no root)** al grupo sudoers para la correcta ejecución de los scripts.

## Paquetes:

Harvester

Maltego

Exiftool

Photon

Spiderfoot

Servicio Tor

Navegador Tor

Recon-NG

FOCA

Dimitry

GooHack

Sherlock

Sslscan

BurpSuite CE

Sublist3r

Mosint

Osrframework

Paquete de personalización de gnome

## Instalación

Es importante que **NO se ejecute la instalación como root**, ya que **el script está programado para crear los elementos necesarios en el escritorio del usuario**.

**1 -Acceso a root:**

    sudo su

Añadir usuario a sudoers:

    sudo usermod -aG sudo TU_USUARIO

(es posible que necesites reiniciar para aplicar los cambios)

<br>

**2 -Desde tu usuario**

Actualizar repositorios y actualizaciones a última versión:

    sudo apt update && sudo apt upgrade -y

Instalar git, curl, wget

    sudo apt install git curl wget

Para clonar este repositorio:

    git clone https://github.com/XCORNN/MCS_Master_TFM

Modificar permisos para permitir ejecución:

    sudo chmod +x install_All.sh

Ejecutar el script para TODAS las herramientas: 

    sudo ./install_ALL.sh

Instalacion INDIVIDUAL de las herramientas: 
    
    sudo ./install_NOMBREdeHERRAMIENTA.sh

## Uso

### Instalación desde "install_ALL.sh"

Una vez finalizado el script de instalación total, se te pedirá reiniciar el equipo para aplicar los cambios en el escritorio y las extensiones. Tras reiniciar y volver a iniciar sesión, verás que se han añadido las aplicaciones al escritorio y encontrarás un archivo `readme.txt` con las instrucciones de uso para cada una de las aplicaciones, así como sus rutas de instalación. Además, se habrá añadido una extensión de aplicaciones en la parte superior, que te proporcionará accesos directos a cada una de las aplicaciones.

### Instalación Individual

Al finalizar el script de instalación individual, se mostrará en pantalla la información con los comandos necesarios para ejecutarlo. También puedes consultar el archivo `readme.txt` dentro de la carpeta `Files` para revisar las instrucciones de uso de la aplicación.
