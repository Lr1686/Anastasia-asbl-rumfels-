#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence to avoid find errors and subshell forks
if [ -d "$SEARCH_DIR" ]; then
    # Evaluate timestamp once outside loop to avoid subshell forks per file
    NOW=$(date '+%H:%M')
    files=()
    while IFS= read -r file; do
        [ -n "$file" ] && files+=("$file")
        [ "${#files[@]}" -eq 50 ] && break
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \))

    # ⚡ Bolt Optimization: Batch shasum execution across collected files in a single process invocation
    # Guard against empty file array to prevent shasum from hanging on standard input
    if [ "${#files[@]}" -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while IFS= read -r line; do
            hash="${line%% *}"
            file="${line#*  }"
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
