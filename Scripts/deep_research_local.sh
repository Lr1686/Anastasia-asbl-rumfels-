#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence and batch shasum calls to eliminate subshell forks per file
if [ -d "$SEARCH_DIR" ]; then
    NOW=$(date '+%H:%M')
    files=()
    while IFS= read -r file; do
        [ -n "$file" ] && files+=("$file")
        [ "${#files[@]}" -eq 50 ] && break
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \))

    if [ "${#files[@]}" -gt 0 ]; then
        # ⚡ Batch shasum execution across all files in a single process invocation
        shasum -a 256 "${files[@]}" | while IFS= read -r line; do
            hash="${line%% *}"
            file="${line#*  }"
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
