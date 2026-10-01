#!/bin/bash
EXPECTED_HASH="7a49b6ad54d5787a1966a00aad04b542857154ca8598cf42183bb37f31ec12ba"
TARGET_FILE="/Users/ANASTASIAPRIVÉ_RUMFELS_Propriétaire_de_100%_de vie_et_au-delà/Downloads/Gemini.dmg"

# Fast-path: check file existence to avoid executing shasum on missing targets
if [ ! -f "$TARGET_FILE" ]; then
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
  exit 0
fi

# Optimization: Use Bash parameter expansion instead of piping to awk to eliminate external subshell process forks
RAW_HASH=$(shasum -a 256 "$TARGET_FILE" 2>/dev/null)
ACTUAL_HASH=${RAW_HASH%% *}

if [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
  echo "✅ NOMAD : Intégrité certifiée. Fréquence 12_ALPHA stable."
else
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
fi
