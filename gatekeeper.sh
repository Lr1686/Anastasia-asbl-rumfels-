#!/bin/bash
EXPECTED_HASH="${EXPECTED_HASH:-7a49b6ad54d5787a1966a00aad04b542857154ca8598cf42183bb37f31ec12ba}"
TARGET_FILE="${TARGET_FILE:-/Users/ANASTASIAPRIVÉ_RUMFELS_Propriétaire_de_100%_de vie_et_au-delà/Downloads/Gemini.dmg}"

# Performance optimization: Fast-path check to avoid process forks if target file is missing
if [ ! -f "$TARGET_FILE" ]; then
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
  exit 0
fi

# Calculate hash and use Bash parameter expansion to avoid piping to awk
RAW_OUTPUT=$(shasum -a 256 "$TARGET_FILE")
ACTUAL_HASH="${RAW_OUTPUT%% *}"

if [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
  echo "✅ NOMAD : Intégrité certifiée. Fréquence 12_ALPHA stable."
else
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
fi
