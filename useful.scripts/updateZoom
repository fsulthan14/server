#!/usr/bin/env bash

## Contoh Versi: 6.4.3 (827). maka argumennya jadi : ./updateZoom.sh 6.4.3.827

# Ambil versi dari argumen, jika ada
ver="$1"
cd /tmp || exit 1
file="zoom_amd64.deb"

if [ -n "$ver" ]; then
  url="https://cdn.zoom.us/prod/${ver}/$file"
  echo "Downloading Zoom version $ver..."
else
  url="https://zoom.us/client/latest/$file"
  echo "Downloading latest Zoom package..."
fi

echo
wget -N "$url" || { echo "Download failed"; exit 1; }

# Ambil versi dari file .deb
ver_dl=$(dpkg-deb -f $file Version 2>/dev/null) || { echo "Gagal baca versi"; exit 1; }
echo "Zoom version $ver_dl downloaded."

# Cek versi yang sudah terinstal
ver_inst=$(dpkg -s zoom 2>/dev/null | grep '^Version:' | cut -d' ' -f2)

if [ "$ver_dl" != "$ver_inst" ]; then
  echo "Installing $file..."
  sudo dpkg -i $file
  sudo apt-get install -f -y
else
  echo "Zoom is already up to date (version $ver_inst)."
fi
