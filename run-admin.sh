#!/usr/bin/env bash
# Bagian yang butuh root: install script & polkit browser, polkit gasiwfh,
# lalu update Chrome & Firefox. Aman di-re-run (idempotent): tiap langkah
# cuma mengubah sesuatu kalau memang perlu.
# Jalankan oleh admin: sudo ./run-admin.sh
# Bagian untuk user biasa (tanpa sudo) ada di run.sh.
set -u

[[ $EUID -eq 0 ]] || { echo "Run as root: sudo ./run-admin.sh"; exit 1; }

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
  if cmp -s "$src" "$dst"; then
    echo "Polkit gasiwfh sudah terpasang."
    return
  fi
  "$SCRIPTS/polkit/add-polkit.sh"
}

step "Install script & polkit browser" "$DIR/install.sh"
step "Polkit gasiwfh" installPolkitWfh
step "Update Chrome" "$SCRIPTS/updateChrome"
step "Update Firefox" "$SCRIPTS/updateFirefox"

echo
if [ ${#failed[@]} -eq 0 ]; then
  echo "Semua langkah admin selesai."
else
  echo "Selesai, tapi ada yang gagal:"
  printf '  - %s\n' "${failed[@]}"
  exit 1
fi
