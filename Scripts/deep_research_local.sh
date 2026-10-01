#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
find ~/StudioIA -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) 2>/dev/null | head -50 | while read -r file; do
    # Optimization: Use Bash parameter expansion instead of piping to awk to eliminate process forks inside loop
    RAW_HASH=$(shasum -a 256 "$file" 2>/dev/null)
    hash=${RAW_HASH%% *}
    echo "[$(date '+%H:%M')] ANALYSE → $file | Hash: ${hash:0:16}..."
done
