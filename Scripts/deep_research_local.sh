#!/bin/bash
echo "🔬 Deep Research Local – Janus Scanning StudioIA"
SEARCH_DIR="$HOME/StudioIA"

# ⚡ Bolt Optimization: Fast-path check directory existence to avoid find errors and subshell forks
if [ -d "$SEARCH_DIR" ]; then
    # Collect null-terminated paths into Bash array capped at 50 without GNU flags (macOS compatible)
    files=()
    while IFS= read -r -d '' file; do
        files+=("$file")
        [ ${#files[@]} -ge 50 ] && break
    done < <(find "$SEARCH_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.json" \) -print0)

    # ⚡ Bolt Optimization: Batch shasum in single process invocation to eliminate per-file fork overhead
    if [ ${#files[@]} -gt 0 ]; then
        NOW=$(date '+%H:%M')
        shasum -a 256 "${files[@]}" | while read -r hash file; do
            echo "[$NOW] ANALYSE → $file | Hash: ${hash:0:16}..."
        done
    fi
fi
