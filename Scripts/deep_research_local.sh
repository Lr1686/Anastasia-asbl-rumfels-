#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence to avoid find errors and subshell forks
if [ -d "$SEARCH_DIR" ]; then
    # Evaluate timestamp once outside loop to avoid subshell forks per file
    NOW=$(date '+%H:%M')
    files=()
    count=0
    # Collect up to 50 files safely handling spaces and special characters
    while IFS= read -r -d '' file; do
        files+=("$file")
        ((count++))
        if [ "$count" -ge 50 ]; then
            break
        fi
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -print0 2>/dev/null)

    # ⚡ Bolt Optimization: Batch shasum execution across collected files in a single process invocation
    if [ "${#files[@]}" -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while read -r hash file; do
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
