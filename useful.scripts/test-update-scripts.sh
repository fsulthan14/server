#!/usr/bin/env bash
# Self-check: pastikan semua script masih valid syntax-nya.
set -e
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for f in "$DIR"/updateChrome "$DIR"/updateFirefox "$DIR"/clearBrowserHistory "$DIR"/cleanUserDirs "$DIR"/../install.sh "$DIR"/../run.sh; do
  bash -n "$f" && echo "OK: $f"
done
