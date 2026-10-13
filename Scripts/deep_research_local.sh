#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence to avoid find errors and subshell forks
if [ -d "$SEARCH_DIR" ]; then
    # Evaluate timestamp once outside loop to avoid subshell forks per file
    NOW=$(date '+%H:%M')
    files=()
    count=0
    while IFS= read -r -d '' file && [ $count -lt 50 ]; do
        [ -n "$file" ] && files+=("$file")
        ((count++))
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -print0 2>/dev/null)

    # ⚡ Bolt Optimization: Batch shasum in a single invocation to eliminate subshell process fork overhead per file
    if [ ${#files[@]} -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while read -r line; do
            hash="${line%% *}"
            file="${line#*  }"
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
