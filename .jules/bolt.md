## 2026-10-07 - Shell Script Subshell Overhead & Fast-Path Checks
**Learning:** In gatekeeper.sh and deep_research_local.sh, invoking external commands (shasum, awk, date) inside loops or without fast-path file/directory existence checks causes significant subshell fork overhead and error output when files/directories are missing.
**Action:** Always check file/directory existence using bash built-ins `[ -f ... ]` / `[ -d ... ]`, hoist invariant command calls outside loops, and use bash parameter expansion instead of piping to awk.

## 2026-10-07 - Batch Command Execution via Array Collection in Shell Scripts
**Learning:** Invoking external commands like `shasum` inside a `while read` loop for multiple files creates a process fork for each file (e.g. 50 process forks taking ~1.6s). Collecting null-terminated file paths (`find -print0` with `IFS= read -r -d ''`) into a Bash array and passing them to `shasum` in a single invocation reduces process forks from N to 1, delivering ~38x speedup (~0.04s).
**Action:** Batch external utility invocations by accumulating file arguments into a Bash array using `-print0` rather than running external commands per file inside loops.
