#!/bin/bash

# USE UBUNTU SERVER 22 BY FAQIHSULTHAN @ 2024

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# install dependencies
apt update && apt upgrade -y
apt install git apache2 libapache2-mod-php php-mysql php-mbstring php-curl php-tokenizer php-xmlrpc php-soap php-zip php-gd php-xml php-intl mariadb-server -y

# install moodle 
cd /tmp
git clone 
