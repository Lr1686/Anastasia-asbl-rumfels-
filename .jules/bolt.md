## 2026-10-07 - Shell Script Subshell Overhead & Fast-Path Checks
**Learning:** In gatekeeper.sh and deep_research_local.sh, invoking external commands (shasum, awk, date) inside loops or without fast-path file/directory existence checks causes significant subshell fork overhead and error output when files/directories are missing.
**Action:** Always check file/directory existence using bash built-ins `[ -f ... ]` / `[ -d ... ]`, hoist invariant command calls outside loops, and use bash parameter expansion instead of piping to awk.

## 2026-10-24 - Batching Shell File Hash Processing to Eliminate Process Forks
**Learning:** Invoking `shasum` inside a `while read` loop for scanned files causes a subshell fork per file (e.g. 50 process creations for 50 files). Collecting null-delimited file paths into a Bash array (`find -print0` with `IFS= read -r -d ''`) and passing `${files[@]}` to a single `shasum` call eliminates process creation overhead (50 forks down to 1), accelerating scan runtime by ~32x (1.39s -> 0.04s).
**Action:** Always batch array arguments for CLI utilities like `shasum` instead of calling them iteratively inside shell loops.
