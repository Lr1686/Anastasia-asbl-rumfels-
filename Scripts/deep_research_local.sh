#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
TARGET_DIR="$HOME/StudioIA"

# Performance optimization:
# 1. Fast-path directory check: avoids invoking find command if $TARGET_DIR does not exist.
# 2. Pure parameter expansion ${hash%% *} avoids spawning external awk processes per file.
# 3. read -r and quoted variables ensure space-safe path handling without string corruption.

if [ -d "$TARGET_DIR" ]; then
    find "$TARGET_DIR" -maxdepth 2 -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) | head -50 | while read -r file; do
        RAW_OUTPUT=$(shasum -a 256 "$file" 2>/dev/null)
        hash="${RAW_OUTPUT%% *}"
        echo "[$(date '+%H:%M')] ANALYSE → $file | Hash: ${hash:0:16}..."
    done
else
    echo "⚠️ Repertoire $TARGET_DIR introuvable."
fi
