#!/bin/bash

if [ "$EUID" -ne 0 ]
then
  echo "[ERROR] Please run as root..."
  echo
  exit 1
fi

dirName=$(dirname "$0")
filePath="/etc/polkit-1/localauthority/50-local.d/gasiwfh.pkla"

echo "[INFO] Installing gasiwfh network manager polkit"

if [ -f "$filePath" ]; then
    rm -f "$filePath"
    echo "[INFO] File gasiwfh.pkla telah dihapus."
fi

cp "${dirName}/gasiwfh.pkla" "$filePath"

systemctl restart polkit.service

echo "[INFO] Done"
