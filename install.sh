#!/usr/bin/env bash
set -e

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo ./install.sh"; exit 1; }

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# `install` overwrites in place dengan permission yang sama tiap kali
# dijalankan, jadi aman di-re-run (idempotent), tidak ada duplikasi.
install -m 755 "$DIR/useful.scripts/updateChrome" /usr/local/bin/updateChrome
install -m 755 "$DIR/useful.scripts/updateFirefox" /usr/local/bin/updateFirefox
install -m 755 "$DIR/useful.scripts/clearBrowserHistory" /usr/local/bin/clearBrowserHistory
install -D -m 644 "$DIR/polkit/49-gasi-update-browsers.rules" /etc/polkit-1/rules.d/49-gasi-update-browsers.rules

echo "Terpasang: /usr/local/bin/updateChrome, /usr/local/bin/updateFirefox, /usr/local/bin/clearBrowserHistory"
