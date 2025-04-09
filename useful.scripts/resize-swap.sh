#!/bin/bash

# ============ KONFIGURASI ============
SWAPFILE="/swapfile"
FSTAB="/etc/fstab"
# =====================================

# Fungsi error
die() {
  echo "[ERROR] $1" >&2
  exit 1
}

# Validasi root
if [[ "${EUID}" -ne 0 ]]; then
  die "Script ini harus dijalankan sebagai root!"
fi

# Validasi input
if [[ -z "${1}" ]]; then
  die "Ukuran swap wajib diinput. Contoh: sudo ./resize_swap.sh 2G"
fi

FORMAT="${1}"

echo "[INFO] Menonaktifkan swap lama..."
swapoff -a || die "Gagal menonaktifkan swap"

if [[ -f "${SWAPFILE}" ]]; then
  echo "[INFO] Menghapus swapfile lama..."
  rm -f "${SWAPFILE}" || die "Gagal menghapus ${SWAPFILE}"
fi

echo "[INFO] Membuat swapfile baru sebesar ${FORMAT} dengan fallocate..."
fallocate -l "${FORMAT}" "${SWAPFILE}" || die "Gagal membuat swapfile dengan fallocate"

chmod 600 "${SWAPFILE}" || die "Gagal mengatur permission"
mkswap "${SWAPFILE}" || die "Gagal menjalankan mkswap"
swapon "${SWAPFILE}" || die "Gagal mengaktifkan swap"

if ! grep -q "^${SWAPFILE}" "${FSTAB}"; then
  echo "[INFO] Menambahkan ${SWAPFILE} ke ${FSTAB}..."
  cp "${FSTAB}" "${FSTAB}.bak"
  echo "${SWAPFILE} none swap sw 0 0" >> "${FSTAB}"
fi

echo "[SUCCESS] Swap berhasil diatur ke ${FORMAT}"
free -h

echo "[INFO] Rebooting sekarang..."
reboot

