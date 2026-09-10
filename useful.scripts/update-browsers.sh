#!/usr/bin/env bash
set -e

# Dipanggil lewat pkexec (lihat polkit/49-gasi-update-browsers.rules), jadi
# script ini jalan sebagai root. sudo di dalam updateChrome/updateFirefox
# tetap aman dijalankan sebagai root (pam_rootok, tidak minta password).
export DEBIAN_FRONTEND=noninteractive

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "== Updating OS packages =="
apt-get update -qq
apt-get upgrade -y

echo "== Updating Chrome =="
"$DIR/updateChrome"

echo "== Updating Firefox =="
"$DIR/updateFirefox"
