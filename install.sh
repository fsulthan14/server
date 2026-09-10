#!/usr/bin/env bash
set -e

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo ./install.sh"; exit 1; }

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

install -m 755 "$DIR/useful.scripts/updateChrome" /usr/local/sbin/updateChrome
install -m 755 "$DIR/useful.scripts/updateFirefox" /usr/local/sbin/updateFirefox
install -m 755 "$DIR/useful.scripts/update-browsers.sh" /usr/local/sbin/update-browsers.sh

install -m 644 "$DIR/polkit/49-gasi-update-browsers.rules" /etc/polkit-1/rules.d/49-gasi-update-browsers.rules

install -m 644 "$DIR/systemd/gasi-update-browsers.service" /etc/systemd/user/gasi-update-browsers.service
install -m 644 "$DIR/systemd/gasi-update-browsers.timer" /etc/systemd/user/gasi-update-browsers.timer

systemctl --global enable gasi-update-browsers.timer

echo "Selesai. Timer aktif untuk semua user (systemd --user) setelah mereka login berikutnya."
