#!/bin/bash
echo "© Wayne Enterprises Pvt Ltd"
echo "MySQL root password : "
read MySQLrootpassword
sudo apt-get update
sudo apt-get install apache2 -y
sudo echo "mysql-server mysql-server/root_password select $MySQLrootpassword" | debconf-set-selections
sudo echo "mysql-server mysql-server/root_password_again select $MySQLrootpassword" | debconf-set-selections
# Depretiated : export DEBIAN_FRONTEND=noninteractive
sudo  apt-get install mysql-server php5-mysql -y
# Depretiated : mysqladmin -u root password $MySQLrootpassword
sudo mysql_install_db

sudo mysql -sfu root "DELETE FROM mysql.user WHERE User='';"
sudo mysql -sfu root "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -sfu root "DROP DATABASE test;"
sudo mysql -sfu root "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
sudo mysql -sfu root "FLUSH PRIVILEGES;"

sudo apt-get install -y php5 libapache2-mod-php5 php5-mcrypt

sudo echo /etc/apache2/mods-enabled/dir.conf <  "<IfModule mod_dir.c>"
sudo echo /etc/apache2/mods-enabled/dir.conf << "<DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm"
sudo echo /etc/apache2/mods-enabled/dir.conf << "</IfModule>"

sudo service apache2 restart
