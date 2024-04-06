#!/bin/bash

#only root
if [ "$EUID" -ne 0 ]
then
  echo "[ERROR] Please run as root..."
  echo
  exit 1
fi

#global variabel
passbolt_username=passbolt
passbolt_password=$(echo "==gCxIDMyAEapNXYpJ3U" | rev | base64 -d)
dbpass=/var/local/dbPassword.lst
echo "Passbolt db on  $(hostname -I):" > ${dbpass}
echo ${passbolt_password} >> ${dbpass} 
passbolt_db=passbolt

#repo setup
wget "https://download.passbolt.com/ce/installer/passbolt-repo-setup.ce.sh"
wget https://github.com/passbolt/passbolt-dep-scripts/releases/latest/download/passbolt-ce-SHA512SUM.txt
sha512sum -c passbolt-ce-SHA512SUM.txt && sudo bash ./passbolt-repo-setup.ce.sh  || echo \"Bad checksum. Aborting\" && rm -f passbolt-repo-setup.ce.sh

#install passbolt
echo passbolt-ce-server passbolt/mysql-configuration boolean true | debconf-set-selections
echo passbolt-ce-server passbolt/mysql-passbolt-username string ${passbolt_username} | debconf-set-selections
echo passbolt-ce-server passbolt/mysql-passbolt-password password ${passbolt_password} | debconf-set-selections
echo passbolt-ce-server passbolt/mysql-passbolt-password-repeat password ${passbolt_password} | debconf-set-selections
echo passbolt-ce-server passbolt/mysql-passbolt-dbname string ${passbolt_db} | debconf-set-selections
echo passbolt-ce-server passbolt/nginx-configuration boolean false | debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt-get install passbolt-ce-server -y

rm /etc/nginx/sites-available/default && rm /etc/nginx/sites-enabled/default
systemctl restart nginx

#mounting
mkdir /mnt/backups
