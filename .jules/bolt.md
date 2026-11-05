## 2026-10-07 - Shell Script Subshell Overhead & Fast-Path Checks
**Learning:** In gatekeeper.sh and deep_research_local.sh, invoking external commands (shasum, awk, date) inside loops or without fast-path file/directory existence checks causes significant subshell fork overhead and error output when files/directories are missing.
**Action:** Always check file/directory existence using bash built-ins `[ -f ... ]` / `[ -d ... ]`, hoist invariant command calls outside loops, and use bash parameter expansion instead of piping to awk.

## 2026-10-24 - Batch Processing for Hashing Invocations
**Learning:** In `deep_research_local.sh`, invoking `shasum` individually for each file within a `while read` loop incurs ~50 separate process fork/exec calls. Batching file arguments to a single `shasum -a 256 "${files[@]}"` call slashes execution time by >97% while safely preserving paths with spaces or quotes.
**Action:** Collect file lists into Bash arrays with `read -r` and pass the array directly to hash or validation utilities guarded by an array length check.
