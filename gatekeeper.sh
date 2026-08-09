#!/bin/bash
EXPECTED_HASH="7a49b6ad54d5787a1966a00aad04b542857154ca8598cf42183bb37f31ec12ba"
ACTUAL_HASH=$(shasum -a 256 /Users/ANASTASIAPRIVÉ_RUMFELS_Propriétaire_de_100%_de vie_et_au-delà/Downloads/Gemini.dmg | awk '{print $1}')

if [ "$EXPECTED_HASH" == "$ACTUAL_HASH" ]; then
  echo "✅ NOMAD : Intégrité certifiée. Fréquence 12_ALPHA stable."
else
  echo "⚠️ ALERTE : La Boîte Noire a été altérée. Sécurité compromise."
fi
