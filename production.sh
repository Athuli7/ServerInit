#!/bin/bash
echo "© Wayne Enterprises Pvt Ltd"
echo "MySQL root password : "
read MySQLrootpassword
sudo apt-get update
sudo apt-get install apache2 -y
echo "mysql-server mysql-server/root_password select (password omitted)" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again select (password omitted)" | debconf-set-selections
# Deprectiated : export DEBIAN_FRONTEND=noninteractive
sudo  apt-get install mysql-server php5-mysql -y
mysqladmin -u root password $MySQLrootpassword
sudo mysql_install_db

mysql -sfu root "DELETE FROM mysql.user WHERE User='';"
mysql -sfu root "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
mysql -sfu root "DROP DATABASE test;"
mysql -sfu root "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
mysql -sfu root "FLUSH PRIVILEGES;"

sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt

echo /etc/apache2/mods-enabled/dir.conf <  "<IfModule mod_dir.c>"
echo /etc/apache2/mods-enabled/dir.conf << "<DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm"
echo /etc/apache2/mods-enabled/dir.conf << "</IfModule>"

sudo service apache2 restart
