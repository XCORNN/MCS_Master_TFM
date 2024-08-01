# MCS_Master_TFM
Master_TFM

Este repositorio tiene como objetivo automatizar las descargas e instalaciones de ciertas herramientas de OSINT en un Entorno Debian 12 limpio, para realizar un desplegamiento rapido y seguro.

Mediante la descarga del repositorio obtienes los script de ejecución para crear todo el desplegamiento o tan solo las herraminentas necesarias, puedes ejecutar el script "install_ALL.sh" o puedes utilizar el script "install_NOMBREdeHERRAMIENTA"

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

Para clonar este repositorio:

    "git clone https://github.com/XCORNN/MCS_Master_TFM"

Modificar permisos para permitir ejecución:

    "chmod +x install_All.sh"

Ejecución del scrip (root)

    "sudo ./ install_All"
