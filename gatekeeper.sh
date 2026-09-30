#!/bin/bash
EXPECTED_HASH="7a49b6ad54d5787a1966a00aad04b542857154ca8598cf42183bb37f31ec12ba"
TARGET_FILE="/Users/ANASTASIAPRIVÉ_RUMFELS_Propriétaire_de_100%_de vie_et_au-delà/Downloads/Gemini.dmg"

# Fast-path check: avoid fork/exec overhead of shasum and awk if target file is missing
if [ -f "$TARGET_FILE" ]; then
  # Eliminate awk process fork by using Bash parameter expansion
  RAW_HASH=$(shasum -a 256 "$TARGET_FILE")
  ACTUAL_HASH="${RAW_HASH%% *}"
else
  ACTUAL_HASH=""
fi

if [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
  echo "✅ NOMAD : Intégrité certifiée. Fréquence 12_ALPHA stable."
else
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
fi
