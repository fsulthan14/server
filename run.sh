#!/usr/bin/env bash
# Bagian untuk user biasa (tanpa sudo): hapus history browser, lalu
# bersihin folder user. Aman di-re-run (idempotent).
# Jalankan sebagai user yang mau dibersihkan: ./run.sh
# Bagian yang butuh root (install, polkit, update browser) ada di run-admin.sh.
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
