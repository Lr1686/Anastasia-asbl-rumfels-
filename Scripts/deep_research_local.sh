#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence to avoid find errors and subshell forks
if [ -d "$SEARCH_DIR" ]; then
    # Evaluate timestamp once outside loop to avoid subshell forks per file
    NOW=$(date '+%H:%M')
    # ⚡ Bolt Optimization: Batch shasum execution into a single call to eliminate per-file process forks
    files=()
    while IFS= read -r file; do
        [ -n "$file" ] && files+=("$file")
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) | head -50)

    if [ ${#files[@]} -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while read -r hash file; do
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
