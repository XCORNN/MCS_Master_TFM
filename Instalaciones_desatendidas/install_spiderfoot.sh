mkdir -p $HOME/Escritorio/Spiderfoot

cd $HOME/Escritorio/Spiderfoot

wget https://github.com/smicallef/spiderfoot/archive/refs/tags/v4.0.tar.gz

if [ which pip3 &>/dev/null ];
then
	sudo pip3 install lxml netaddr cherrypy mako requests bs4 pyyaml --break-system-packages
else
	sudo apt-get install -y python3-pip
	sudo pip3 install lxml netaddr cherrypy mako requests bs4 pyyaml --break-system-packages
fi

sudo apt-get install python3-m2crypto

tar xzvf v4.0.tar.gz
cd spiderfoot-4.0
sed -i '/pyyaml/d' requirements.txt
pip3 install -r requirements.txt --break-system-packages
