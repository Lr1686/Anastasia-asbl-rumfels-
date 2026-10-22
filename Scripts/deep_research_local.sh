#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence and batch shasum calls into a single invocation to eliminate process fork overhead
if [ -d "$SEARCH_DIR" ]; then
    # Evaluate timestamp once outside loop to avoid subshell forks
    NOW=$(date '+%H:%M')
    files=()
    count=0
    while IFS= read -r -d '' file; do
        files+=("$file")
        ((count++))
        if [ "$count" -ge 50 ]; then break; fi
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -print0)

    if [ ${#files[@]} -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while read -r hash file; do
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
