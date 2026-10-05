#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"

SEARCH_DIR="${HOME}/StudioIA"
if [ ! -d "$SEARCH_DIR" ]; then
  exit 0
fi

# Performance optimization: Hoist static date calculation and eliminate subshell forks to awk
TIMESTAMP=$(date '+%H:%M')
find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) | head -50 | while IFS= read -r file; do
    raw_hash=$(shasum -a 256 "$file")
    hash="${raw_hash%% *}"
    echo "[$TIMESTAMP] ANALYSE → $file | Hash: ${hash:0:16}..."
done
