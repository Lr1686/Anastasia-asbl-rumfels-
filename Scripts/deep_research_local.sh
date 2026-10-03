#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"

SEARCH_DIR="$HOME/StudioIA"

# Performance optimization: Fast-path check to avoid running find when directory does not exist
if [ ! -d "$SEARCH_DIR" ]; then
    exit 0
fi

# Hoist date calculation outside loop to avoid repeated process spawning
TIMESTAMP=$(date '+%H:%M')

find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) | head -50 | while IFS= read -r file; do
    # Use Bash parameter expansion instead of piping to awk to avoid process forks
    RAW_HASH=$(shasum -a 256 "$file" 2>/dev/null)
    HASH="${RAW_HASH%% *}"
    echo "[$TIMESTAMP] ANALYSE → $file | Hash: ${HASH:0:16}..."
done
