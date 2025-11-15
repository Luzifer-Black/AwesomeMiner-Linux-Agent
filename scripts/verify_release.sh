#!/usr/bin/env bash
if [ $# -lt 2 ]; then echo "Usage: $0 file signature.asc"; exit 2; fi
gpg --verify "$2" "$1"
