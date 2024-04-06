# IaC for Moodle

#!/bin/bash
# only root should execute this script
if [ "$EUID" -ne 0 ]
then
  echo "[ERROR] Please run as root..."
  echo
  exit 1
fi

MOODLE_VERSION=MOODLE_311_STABLE

# Download PHP 7.4
apt-get update
add-apt-repository ppa:ondrej/php -y
DEBIAN_FRONTEND=noninteractive apt install php7.4 libapache2-mod-php7.4 -y

#Install the remaining PHP 7.4 packages
apt install graphviz aspell ghostscript clamav php7.4-pspell php7.4-curl php7.4-gd php7.4-intl php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-ldap php7.4-zip php7.4-soap php7.4-mbstring git -y

#Reload Apache to apply the changes
systemctl restart apache2

# Download Moodle
# Move to the /opt directory, and clone the Moodle Git repository:
cd /opt
git clone git://git.moodle.org/moodle.git

# go to moodle directory
cd moodle

# Track and check out the appropriate branch
git branch --track ${MOODLE_VERSION} origin/${MOODLE_VERSION}
git checkout ${MOODLE_VERSION}

# Copy the contents of the Moodle to /var/www/html
cp -R /opt/moodle /var/www/html/

# Modify the permissions for the moodle directory to grant read, write, and execute rights to all users
chmod -R 0777 /var/www/html/moodle

# Create the /var/moodledata directory and change the directory owner and permissions.
mkdir /var/moodledata
chown -R www-data /var/moodledata
chmod -R 0777 /var/moodledata

# Install MariaDB
sudo apt-get install mariadb-server -y

# create a database and user
printf "\n[INFO] Create user & database...\n"
DB_PASSWORD='Moodle@gasi'
DB_USER='moodleuser'
DATABASE='moodledb'
mysql -e "
   DROP DATABASE IF EXISTS ${DATABASE};
   DROP USER IF EXISTS '${DB_USER}'@'localhost';
   CREATE DATABASE ${DATABASE} CHARACTER SET utf8mb4;
   GRANT ALL PRIVILEGES ON ${DATABASE}.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
   FLUSH PRIVILEGES;
"

#copy file config.php to /var/www/html/moodle
cp config.php /var/www/html/moodle

