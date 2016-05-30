#!/bin/bash
echo "Server Init 30-05-2016"
echo "© Wayne Enterprises Pvt Ltd"
# Root check
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi
#
sudo apt-get install -y pwgen
echo "Set own Passwords ? Type 'Yes' :"
read setPassword
if ("$setPassword" == "Yes") then
echo "MySQL root password : "
read MySQLrootpassword
echo "phpMyAdmin password : "
read phpMyAdminpassword
else
MySQLrootpassword = `pwgen -c -1 21`
phpMyAdminpassword = `pwgen -c -1 21`
fi

sudo apt-get update
sudo apt-get install -y git htop
sudo apt-get install apache2 -y
sudo echo "mysql-server mysql-server/root_password select $MySQLrootpassword" | debconf-set-selections
sudo echo "mysql-server mysql-server/root_password_again select $MySQLrootpassword" | debconf-set-selections
# Depretiated : export DEBIAN_FRONTEND=noninteractive
sudo  apt-get install mysql-server php5-mysql -y
# Depretiated : mysqladmin -u root password $MySQLrootpassword
sudo mysql_install_db

sudo mysql -sfu root --password=$MySQLrootpassword "DELETE FROM mysql.user WHERE User='';"
sudo mysql -sfu root --password=$MySQLrootpassword "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -sfu root --password=$MySQLrootpassword "DROP DATABASE test;"
sudo mysql -sfu root --password=$MySQLrootpassword "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -sfu root --password=$MySQLrootpassword "FLUSH PRIVILEGES;"

sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

sudo echo "<IfModule mod_dir.c>" > /etc/apache2/mods-enabled/dir.conf
sudo echo "DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm" >> /etc/apache2/mods-enabled/dir.conf
sudo echo "</IfModule>" >> /etc/apache2/mods-enabled/dir.conf

sudo service apache2 restart

sudo apt-get install -y php5-cgi php5-cli php5-curl php5-common php5-dbg php5-dev php5-gd
sudo a2enmod rewrite

sudo echo "<?php phpinfo(); ?>" > /var/www/html/index.php

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MySQLrootpassword" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $phpMyAdminpassword" |debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $phpMyAdminpassword" | debconf-set-selections

sudo apt-get install -y phpmyadmin apache2-utils



###Winding up
if( "$setPassword" == "Yes") then
$MySQLrootpassword = "as Set"
$phpMyAdminpassword = "as Set"
fi
echo "Report :-"
echo "MySQL root password : $MySQLrootpassword"
echo "phpMyAdmin passsword : $phpMyAdminpassword"
