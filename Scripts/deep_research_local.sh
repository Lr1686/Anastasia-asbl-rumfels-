#!/bin/bash
# Performance optimization:
# 1. Fast-path check: Return early if search directory does not exist to avoid spawning find/shasum.
# 2. Hoist constant computation: Calculate TIMESTAMP outside the file processing loop to eliminate subshell forks on every iteration.
# 3. In-process parsing: Use Bash parameter expansion (${RAW_HASH%% *}) instead of piping to awk inside the loop.
# 4. Safe read & quoting: Use read -r and quote file paths.

echo "🔬 Deep Research Local – Janus Scanning StudioIA"

SEARCH_DIR="${SEARCH_DIR:-$HOME/StudioIA}"

if [ ! -d "$SEARCH_DIR" ]; then
    exit 0
fi

TIMESTAMP=$(date '+%H:%M')

find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) | head -50 | while IFS= read -r file; do
    RAW_HASH=$(shasum -a 256 "$file" 2>/dev/null)
    HASH="${RAW_HASH%% *}"
    echo "[$TIMESTAMP] ANALYSE → $file | Hash: ${HASH:0:16}..."
done
