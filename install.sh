#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$ROOT_DIR/scripts"

mapfile -d '' scripts < <(
    find "$SCRIPTS_DIR" -maxdepth 1 -type f -name '*.sh' -print0 | sort -z
)

if [[ ${#scripts[@]} -eq 0 ]]; then
    echo "No hay scripts .sh en $SCRIPTS_DIR" >&2
    exit 1
fi

for script in "${scripts[@]}"; do
    echo "==> Ejecutando $(basename "$script")"
    bash "$script"
done

echo "Instalación completa."
