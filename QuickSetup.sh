#!/bin/bash

##################################################################################################
# Author: Kamran Babar                                                                         #
# Description: Quick Setup bash script to setup required programs after doing fresh OS install.      #
# Tested against Debian based distributions like Ubuntu.                       #
##################################################################################################

if [[ ! -z $(which figlet) ]]; then
    # Do Nothing
    echo "Welcome to"
else
    sudo apt install figlet toilet -y
fi

c='\e[32m'         # Coloured echo (Green)
y=$'\033[38;5;11m' # Coloured echo (yellow)
r='tput sgr0'      #Reset colour after echo

# Color Reset
Color_Off='\033[0m' # Reset

# Regular Colors
Red='\033[0;31m'    # Red
Green='\033[0;32m'  # Green
Yellow='\033[0;33m' # Yellow
Blue='\033[0;34m'   # Blue
Purple='\033[0;35m' # Purple
Cyan='\033[0;36m'   # Cyan

#Display Banner
printf "${Cyan}"
figlet -f big "Quick Setup"
echo -e "${Green}                                  - By Kamran Babar"

# 3 seconds wait time to start the setup
for i in $(seq 3 -1 1); do
    echo -ne "${YELLOW} $i\rThe setup will start in... "
    sleep 1
done

# Upgrade and Update Command
echo -e "${c}Updating and upgrading before performing further operations."
$r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y

installSnap() {
    #Snap Installation & Setup
    echo -e "${c}Installing Snap & setting up."
    $r
    sudo apt install -y snapd
    sudo systemctl start snapd
    sudo systemctl enable snapd
    sudo systemctl start apparmor
    sudo systemctl enable apparmor
    export PATH=$PATH:/snap/bin
    sudo snap refresh
}

checkInstalled() {
    echo -e "${c}Checking if $1 is installed."
    $r
    source ~/.profile
    source ~/.bashrc
    if [[ -z $(which $1) ]]; then
        echo -e "${c}$1 is not installed, installing it first."
        $r
        $2
    else
        echo -e "${c}$1 is already installed, Skipping."
        $r
    fi
}

#Executing Install Dialog
dialogbox=(whiptail --separate-output --ok-button "Install" --title "Quick Setup Script" --checklist "\nPlease select required software(s):\n(Press 'Space' to Select/Deselect, 'Enter' to Install and 'Esc' to Cancel)" 30 80 20)
options=(
    1 "Apache2" off
    2 "PHP8.0" off
    3 "MySql" off
    4 "MariaDB" off
    5 "PhpMyAdmin" off
    6 "ProFTPD" off
    7 "SMB" off
    8 "WEBMIN" off
    9 "Docker" off
    10 "Portainer" off
    11 "Enable UFW" off)

selected=$("${dialogbox[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choices in $selected; do
    case $choices in

    1)
        echo ""
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing Apache2"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""
        sudo apt install apache2 -y
        echo "Done installing Apache2"
        echo -e "${Cyan}Apache2 Version"
        sudo apache2 -version
        sudo systemctl stop apache2
        sudo systemctl restart apache2
        echo -e "${Green}Apache2 Installation Done!"
        echo -e "${c}Apache2 Installed Successfully."
        ;;

    2)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing PHP"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""
        echo -e "${Green}Installing Latest PHP!"
        sudo apt install php libapache2-mod-php -y
        sudo apt-get install -y php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath -y
        sudo apt install php8.1-{bcmath,xml,fpm,mysql,zip,intl,ldap,gd,cli,bz2,curl,mbstring,pgsql,opcache,soap,cgi} -y
        sudo php -m
        sudo apt -y install wget php php-cgi php-mysqli php-pear php-mbstring libapache2-mod-php php-common php-phpseclib php-mysql
        sudo apt-get install -y php-tokenizer -y
        sudo apt install php-bcmath -y
        sudo phpenmod mbstring
        sudo a2enmod expires
        sudo a2enmod rewrite
        sudo systemctl restart apache2
        sudo mv /var/www/public_html/index.html /var/www/html/oldindex.html
        sudo echo "<?php phpinfo( ); ?>" >>/var/www//html/index.php
        sudo systemctl reload apache2

        echo -e "${Cyan} Optimizing PHP8.1 ..."
        sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 256M/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/post_max_size = 8M/post_max_size = 256M or 16M/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/;extension=soap/extension=soap/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/;extension=soap/extension=soap/' /etc/php/8.1/apache2/php.ini
        sudo sed -i 's/;extension=xsl/extension=xsl/' /etc/php/8.1/apache2/php.ini

        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing Stable Version of PHP"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""
        sudo apt install software-properties-common
        sudo add-apt-repository ppa:ondrej/php
        sudo apt update
        sudo apt-get install php8.0 php8.0-fpm -y
        sudo apt-get install php8.0-mysql php8.0-mbstring php8.0-xml php8.0-gd php8.0-curl -y
        sudo apt install libapache2-mod-php8.0 libapache2-mod-php -y
        sudo update-alternatives --set php /usr/bin/php8.0
        sudo a2dismod php8.1
        sudo a2enmod php8.0
        sudo a2disconf php8.1-fpm
        sudo a2dismod mpm_prefork
        sudo a2dismod mpm_worker
        sudo a2dismod mpm_event
        sudo apt-get install php-xmlrpc -y
        sudo apt-get install php8.0-xmlrpc -y
        sudo apt-get install -y php8.0-cli php8.0-common php8.0-mysql php8.0-zip php8.0-gd php8.0-mbstring php8.0-curl php8.0-xml php8.0-bcmath -y
        sudo apt install php8.0-{bcmath,xml,fpm,mysql,zip,intl,ldap,gd,cli,bz2,curl,mbstring,pgsql,opcache,soap,cgi} -y
        sudo apt-get install php8.0-soap -y
        sudo apt-get install php-zip -y
        sudo apt install php-sodium -y
        sudo apt-get install unzip -y

        echo -e "${Cyan}Optimizing PHP8.0 ..."
        sudo sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 256M/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/post_max_size = 8M/post_max_size = 256M or 16M/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/max_execution_time = 30/max_execution_time = 300/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/;max_input_vars = 1000/max_input_vars = 5000/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/;extension=soap/extension=soap/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/;extension=soap/extension=soap/' /etc/php/8.0/apache2/php.ini &&
            sudo sed -i 's/;extension=xsl/extension=xsl/' /etc/php/8.0/apache2/php.ini
        ;;

    3)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing MySQL"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""
        sudo apt update
        sudo apt install mysql-server -y

        echo ""
         # read -s "Note: password will be hidden when typing"
        echo -n -e "${Red} Type password for MySQL root user and press enter: "
        read  mysqlrootpassword

        sudo mysql <<eof
  ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${mysqlrootpassword}';
  FLUSH PRIVILEGES
eof
        sudo mysql_secure_installation <<eof
  ${mysqlrootpassword}
  N
  N
  N
  Y
  Y
eof
        sudo ufw allow 3306
        sudo systemctl restart mysql
        echo -e "${c}Installing & Setting up Successfully."
        ;;

    4)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing MariaDB"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""

        sudo apt update
        sudo apt-get install mariadb-server -y
        
        echo ""
        echo -n -e "${Red} Type password for MySQL root user and press enter: "
        read  mysqlrootpassword

        sudo mysql_secure_installation <<eof
  
  Y
  Y
  ${mysqlrootpassword}
  ${mysqlrootpassword}
  N
  N
  Y
  Y
eof
        sudo ufw allow 3306
        sudo systemctl restart mariadb
        echo -e "${c}Installing & Setting up Successfully."
        ;;

    5)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing PhpMyAdmin"
        echo -e "${Cyan} -------------------------------------------------- "

        echo ""
        echo ""
        echo -n -e "${Red} Type your current MySQL root password and press enter: "
        i=1
        read mysqlrootpassword
        sudo mysql -u root <<eof
  CREATE USER 'phpmyadmin'@'localhost' IDENTIFIED BY '${mysqlrootpassword}';
  GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
eof
        echo ""

        sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
        sudo service apache2 stop
        sudo mkdir -p /var/lib/phpmyadmin/tmp
        sudo rm /etc/phpmyadmin/config.inc.php
        REALUSER="${SUDO_USER:-${USER}}"
        sudo chown -R ${REALUSER}:${REALUSER} /var/lib/phpmyadmin
        sudo chown -R ${REALUSER}:${REALUSER} /etc/phpmyadmin
        sudo chown -R ${REALUSER}:${REALUSER} /usr/share/phpmyadmin
        sudo cp /home/${REALUSER}/QuickSetup/config.inc.php /etc/phpmyadmin/
        sudo service apache2 start
        echo -e "${c}PHPMyAdmin setup Successfully."
        ;;

    6)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing ProFTPD"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""

        sudo apt-get install proftpd -y
        sudo /etc/init.d/proftpd stop
        sudo rm /etc/proftpd/proftpd.conf
        REALUSER="${SUDO_USER:-${USER}}"
        sudo cp /home/${REALUSER}/quicksetup/proftpd.conf /etc/proftpd/proftpd.conf
        sudo /etc/init.d/proftpd restart
        echo -e "${c}ProFTPD Installed Successfully."
        ;;

    7)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing SMB"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""

        sudo apt-get install samba samba-common-bin -y
        sudo systemctl restart smbd nmbd
        sudo ufw allow 445
        ;;

    8)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing Webmin"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""

        if [ -d "/etc/apache2" ]; then
            sudo apt install wget apt-transport-https software-properties-common -y
            wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
            sudo apt update
            sudo apt install webmin -y

            sudo ufw allow 10000/tcp
            sudo ufw reload

            sudo /etc/webmin/start
            echo -e "${c}Webmin Installed Successfully."
        else
            sudo apt install apache2 -y
            echo "Done installing Apache2"
            echo "${Cyan}Apache2 Version"
            sudo apache2 -version
            sudo systemctl stop apache2
            sudo systemctl restart apache2
            echo "${Green}Apache2 Installation Done!"
            echo -e "${c}Apache2 Installed Successfully."

            sudo apt install wget apt-transport-https software-properties-common -y
            wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
            sudo apt update
            sudo apt install webmin -y

            sudo ufw allow 10000/tcp
            sudo ufw reload

            sudo /etc/webmin/start
            echo -e "${c}Webmin Installed Successfully."
        fi

        ;;

    9)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing Docker"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""
        sudo apt install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
            sudo gpg --dearmor >/etc/apt/trusted.gpg.d/docker.gpg
        echo \
            "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" |
            sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
        sudo apt update
        apt-cache policy docker-ce -y
        sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

        REALUSER="${SUDO_USER:-${USER}}"
        sudo usermod -aG docker ${REALUSER}
        sudo systemctl enable --now docker
        ;;

    10)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Installing Portainer"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""
        sudo docker volume create portainer_data
        sudo docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer
        sudo ufw allow 8000
        sudo ufw allow 9000
        ;;

    11)
        echo -e "${Cyan} -------------------------------------------------- "
        echo -e "${Cyan} -- Enable UFW Firewall"
        echo -e "${Cyan} -------------------------------------------------- "
        echo ""

        sudo ufw allow "Apache Full"
        sudo ufw allow "OpenSSH"
        sudo ufw allow http
        sudo ufw allow https
        sudo ufw allow ssh
        sudo ufw allow 3306
        sudo ufw allow 20/tcp
        sudo ufw allow 21/tcp
        sudo ufw allow 990/tcp
        sudo ufw allow 40000:50000/tcp
        sudo ufw enable
        echo "${RED}Please reboot now!"
        ;;

    esac
done

# Final Upgrade and Update Command
echo -e "${c}Updating and upgrading to finish auto-setup script."
$r
sudo apt update && sudo apt upgrade -y
sudo apt --fix-broken install -y
