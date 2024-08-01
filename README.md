# MCS_Master_TFM
Master_TFM

Este repositorio tiene como objetivo automatizar las descargas e instalaciones de ciertas herramientas de OSINT en un Entorno Debian 12 limpio, para realizar un desplegamiento rapido y seguro.

Mediante la descarga e instalación del repositorio obtienes los script de ejecución para crear todo el desplegamiento o tan solo las herraminentas necesarias.

## Descripción
Herramientas de código abierto utilizadas para la recolección de correos electrónicos, nombres de usuarios, hosts y subdominios de diferentes fuentes públicas como motores de búsqueda y claves PGP.

## Pre-requisitos

Añadir el usuario principal (no root) al grupo sudoers para la correcta ejecución de los scripts.

## Paquetes:

Harvester

Maltego

Exiftool

Photon

Spiderfoot

Tor service

Tor_browser

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

Es importante que NO se ejecuten las instalaciones como root ya que esta programado para que utilice la variable SUDO_USER para crear las necesidades en el escritorio del usuario.

Des de el usuario root:

    "sudo usermod -aG sudo TU_USUARIO"

(es posible que necesites reiniciar para aplicar los cambios)

Actualizar repositorios y actualizaciones a última versión:

    "sudo apt update & upgrade -y"

Para clonar este repositorio:

    "git clone https://github.com/XCORNN/MCS_Master_TFM"

Modificar permisos para permitir ejecución:

    "sudo chmod +x install_All.sh"

Ejecutar el script para TODAS las herramientas: 

    "sudo ./install_ALL.sh" 

Instalacion INDIVIDUAL de las herramientas: 
    
    "sudo ./install_NOMBREdeHERRAMIENTA"
