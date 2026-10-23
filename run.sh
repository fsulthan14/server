#!/usr/bin/env bash
# Jalankan semua sekaligus: install script & polkit, update browser, hapus
# history browser, lalu bersihin folder user. Aman di-re-run (idempotent):
# tiap langkah cuma mengubah sesuatu kalau memang perlu.
# Jalankan sebagai user biasa, langkah yang butuh root pakai sudo.
set -u

if [[ $EUID -eq 0 ]]; then
  echo "Jangan pakai sudo, jalankan sebagai user biasa: ./run.sh"
  exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS="$DIR/useful.scripts"
failed=()

step() {
  local name=$1
  shift
  echo
  echo "==> $name"
  "$@" || failed+=("$name")
}

# add-polkit.sh selalu menimpa file & restart polkit, jadi cuma dipanggil
# kalau file yang terpasang beda dengan yang di repo.
installPolkitWfh() {
  local src="$SCRIPTS/polkit/gasiwfh.pkla"
  local dst=/etc/polkit-1/localauthority/50-local.d/gasiwfh.pkla
  if sudo cmp -s "$src" "$dst"; then
    echo "Polkit gasiwfh sudah terpasang."
    return
  fi
  sudo "$SCRIPTS/polkit/add-polkit.sh"
}

# Minta password sudo sekali di awal.
sudo -v || exit 1

step "Install script & polkit browser" sudo "$DIR/install.sh"
step "Polkit gasiwfh" installPolkitWfh
step "Update Chrome" "$SCRIPTS/updateChrome"
step "Update Firefox" "$SCRIPTS/updateFirefox"
step "Hapus history browser" "$SCRIPTS/clearBrowserHistory"
step "Bersihin folder user" "$SCRIPTS/cleanUserDirs"

echo
if [ ${#failed[@]} -eq 0 ]; then
  echo "Semua langkah selesai."
else
  echo "Selesai, tapi ada yang gagal:"
  printf '  - %s\n' "${failed[@]}"
  exit 1
fi
