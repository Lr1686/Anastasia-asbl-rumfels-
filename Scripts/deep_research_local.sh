#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence to avoid find errors
if [ -d "$SEARCH_DIR" ]; then
    # Evaluate timestamp once outside loop to avoid subshell forks per file
    NOW=$(date '+%H:%M')

    # ⚡ Bolt Optimization: Batch collect up to 50 null-terminated file paths into a bash array
    # and compute shasum in a single batch invocation, reducing process forks from O(N) to O(1)
    files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
        [ "${#files[@]}" -eq 50 ] && break
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -print0)

    if [ "${#files[@]}" -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while read -r line; do
            hash="${line%% *}"
            file="${line#*  }"
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
