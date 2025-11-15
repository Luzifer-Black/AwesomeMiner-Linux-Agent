#!/usr/bin/env bash
if [ -z "${1:-}" ]; then echo "Usage: $0 file"; exit 2; fi
FILE="$1"
gpg --armor --output "${FILE}.asc" --detach-sign "$FILE"
echo "Signed $FILE -> ${FILE}.asc"
