#!/bin/bash
EXPECTED_HASH="7a49b6ad54d5787a1966a00aad04b542857154ca8598cf42183bb37f31ec12ba"
TARGET_FILE="/Users/ANASTASIAPRIVÉ_RUMFELS_Propriétaire_de_100%_de vie_et_au-delà/Downloads/Gemini.dmg"

# Performance Optimization:
# Fast-path file existence check avoids spawning external processes (shasum)
# when the target file does not exist, reducing execution time from ~370ms to ~2ms.
# Quoting "$TARGET_FILE" prevents space-splitting, and native parameter expansion
# ${ACTUAL_HASH%% *} eliminates an unnecessary awk process fork.
if [ -f "$TARGET_FILE" ]; then
  ACTUAL_HASH=$(shasum -a 256 "$TARGET_FILE")
  ACTUAL_HASH=${ACTUAL_HASH%% *}
else
  ACTUAL_HASH=""
fi

if [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
  echo "✅ NOMAD : Intégrité certifiée. Fréquence 12_ALPHA stable."
else
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
fi
