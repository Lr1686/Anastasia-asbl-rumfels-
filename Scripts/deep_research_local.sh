#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence and batch shasum execution
if [ -d "$SEARCH_DIR" ]; then
    NOW=$(date '+%H:%M')
    # Collect up to 50 null-terminated file paths into an array to avoid per-file subshell forks
    files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
        [ ${#files[@]} -ge 50 ] && break
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -print0)

    # Batch shasum calculation in a single process fork instead of 50 process forks
    if [ ${#files[@]} -gt 0 ]; then
        shasum -a 256 "${files[@]}" | while read -r hash file; do
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
