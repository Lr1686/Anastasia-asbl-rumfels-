#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"

# Performance optimization:
# 1. Fast-path check: avoid spawning find, subshell pipelines, and shasum loops when ~/StudioIA directory does not exist.
# 2. Pure parameter expansion ${hash%% *} avoids piping shasum output to awk for each scanned file.

TARGET_DIR="$HOME/StudioIA"

if [ -d "$TARGET_DIR" ]; then
    find "$TARGET_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) | head -50 | while read -r file; do
        if [ -f "$file" ]; then
            hash=$(shasum -a 256 "$file" 2>/dev/null)
            hash="${hash%% *}"
            echo "[$(date '+%H:%M')] ANALYSE → $file | Hash: ${hash:0:16}..."
        fi
    done
fi
