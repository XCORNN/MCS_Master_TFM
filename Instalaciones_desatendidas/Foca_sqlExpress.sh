#!/bin/bash -e

# Usa las siguientes variables para controlar la instalación:

# Contraseña para el usuario SA (requerido)
MSSQL_SA_PASSWORD='Passw0rd!'

# ID de producto de la versión de SQL Server que estás instalando
# Debe ser evaluation, developer, express, web, standard, enterprise, o tu clave de producto de 25 dígitos
# Por defecto es developer
MSSQL_PID='express'

# Habilitar SQL Server Agent (recomendado)
SQL_ENABLE_AGENT='y'

# Instalar SQL Server Full Text Search (opcional)
# SQL_INSTALL_FULLTEXT='y'

# Crear un usuario adicional con privilegios de sysadmin (opcional)
# SQL_INSTALL_USER='<Username>'
# SQL_INSTALL_USER_PASSWORD='<YourStrong!Passw0rd>'

if [ -z $MSSQL_SA_PASSWORD ]
then
  echo La variable de entorno MSSQL_SA_PASSWORD debe estar configurada para la instalación desatendida
  exit 1
fi
echo Ejecutando apt-get update -y...
sudo apt-get update -y
sudo apt-get install -y curl

echo Agregando repositorios de Microsoft...
# Agregar clave GPG de Microsoft
curl -s https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# Agregar el repositorio de SQL Server 2022 para Ubuntu 22.04
sudo wget -O /etc/apt/sources.list.d/mssql-server-2022.list https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list
# Agregar repositorio de producción
sudo wget -O /etc/apt/sources.list.d/prod.list https://packages.microsoft.com/config/ubuntu/22.04/prod.list

echo Ejecutando apt-get update -y...
sudo apt-get update -y

echo Instalando SQL Server...
sudo apt-get install -y mssql-server

echo Ejecutando mssql-conf setup...
sudo MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD \
     MSSQL_PID=$MSSQL_PID \
     /opt/mssql/bin/mssql-conf -n setup accept-eula

echo Instalando mssql-tools y unixODBC developer...
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Habilitar SQL Server Agent (opcional):
if [ ! -z $SQL_ENABLE_AGENT ]
then
  echo Habilitando SQL Server Agent....
  sudo /opt/mssql/bin/mssql-conf set sqlagent.enabled true
fi

# Instalación opcional de SQL Server Full Text Search:
if [ ! -z $SQL_INSTALL_FULLTEXT ]
then
    echo Instalando SQL Server Full-Text Search...
    sudo apt-get install -y mssql-server-fts
fi

# Ejemplo opcional de configuración posterior a la instalación.
# Las flags de rastreo 1204 y 1222 son para el rastreo de interbloqueos.
# echo Configurando flags de rastreo...
# sudo /opt/mssql/bin/mssql-conf traceflag 1204 1222 on

# Agregar herramientas de SQL Server al PATH por defecto:
echo Agregando herramientas de SQL Server a tu PATH...
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

# Reiniciar SQL Server después de la instalación:
echo Reiniciando SQL Server...
sudo systemctl restart mssql-server

# Conectar al servidor y obtener la versión:
counter=1
errstatus=1
while [ $counter -le 5 ] && [ $errstatus = 1 ]
do
  echo Esperando a que SQL Server se inicie...
  sleep 3s
  /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U SA \
    -P $MSSQL_SA_PASSWORD \
    -Q "SELECT @@VERSION" 2>/dev/null
  errstatus=$?
  ((counter++))
done

# Mostrar error si la conexión falló:
if [ $errstatus = 1 ]
then
  echo No se puede conectar a SQL Server, instalación abortada
  exit $errstatus
fi

# Creación opcional de un nuevo usuario:
if [ ! -z $SQL_INSTALL_USER ] && [ ! -z $SQL_INSTALL_USER_PASSWORD ]
then
  echo Creating user $SQL_INSTALL_USER
  /opt/mssql-tools/bin/sqlcmd \
    -S localhost \
    -U SA \
    -P $MSSQL_SA_PASSWORD \
    -Q "CREATE LOGIN [$SQL_INSTALL_USER] WITH PASSWORD=N'$SQL_INSTALL_USER_PASSWORD', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=ON, CHECK_POLICY=ON; ALTER SERVER ROLE [sysadmin] ADD MEMBER [$SQL_INSTALL_USER]"
fi

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

echo ¡Hecho!

#para comprobar si se ha hecho correctamente:
# /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Passw0rd!'
