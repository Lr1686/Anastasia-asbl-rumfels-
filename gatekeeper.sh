#!/bin/bash
EXPECTED_HASH="7a49b6ad54d5787a1966a00aad04b542857154ca8598cf42183bb37f31ec12ba"
TARGET_FILE="/Users/ANASTASIAPRIVÉ_RUMFELS_Propriétaire_de_100%_de vie_et_au-delà/Downloads/Gemini.dmg"

# Performance optimization:
# 1. Fast-path check: avoid spawning external shasum process if target file does not exist (~100% time saved / ~40ms saving when missing).
# 2. Pure parameter expansion ${ACTUAL_HASH%% *} avoids an additional subshell/pipeline fork to awk.
# 3. Proper quoting prevents word splitting errors on filenames containing spaces.

if [ -f "$TARGET_FILE" ]; then
    ACTUAL_HASH=$(shasum -a 256 "$TARGET_FILE" 2>/dev/null)
    ACTUAL_HASH="${ACTUAL_HASH%% *}"
else
    ACTUAL_HASH=""
fi

if [ -n "$ACTUAL_HASH" ] && [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
  echo "✅ NOMAD : Intégrité certifiée. Fréquence 12_ALPHA stable."
else
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
fi
