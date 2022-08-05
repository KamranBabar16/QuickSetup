# QuickSetup

Auto setup is a simple bash script with the command «bash QuickSetup.sh«
The script will automatically add the software sources and install the chosen application.
Firstly change the user and password (for MySQL Root User) into «nano QuickSetup.sh«.

> Keep in mind that this script not fully interactive. We will have to enter the password when necessary.
> For example, suppose we want configure a PHPMyAdmin. To do this, we will write password manually.


## Usage

```bash
git clone https://github.com/KamranBabar16/QuickSetup.git
cd QuickSetup
chmod +x QuickSetup.sh

//add your username and a new password for MySQL root user
nano QuickSetup.sh

./autosetup.sh OR 
bash QuickSetup.sh
```

## List

* Apache2
* PHP8.0
* MySQL
* Mariadb
* PHPMyAdmin
* Proftpd
* SMB
* Webmin
* Docker
* Portainer

## Note

Tested on Ubuntu 22.04 but it should work with other Debian-based distributions as well.
