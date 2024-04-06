#!/bin/bash

# only root should execute this script
if [ "$EUID" -ne 0 ]
then
  echo "[ERROR] Please run as root..."
  echo
  exit 1
fi

#updating system
echo "[INFO] Updating System.."
DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get autoremove -y

# manual install
echo "[INFO] Manual Install.."
DEBIAN_FRONTEND=noninteractive apt-get install inetutils-ping vim ntp -y
