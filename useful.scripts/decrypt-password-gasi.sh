#!/bin/bash
#script ini bisa digunakan untuk dekripsi password user yang terdaftar
#pada gasi linux server.

echo "masukin password:"
read password

echo "password ente adalah:"
echo ${password} | cut -c 4-31 | rev | base64 -d
