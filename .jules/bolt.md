## 2026-10-07 - Shell Script Subshell Overhead & Fast-Path Checks
**Learning:** In gatekeeper.sh and deep_research_local.sh, invoking external commands (shasum, awk, date) inside loops or without fast-path file/directory existence checks causes significant subshell fork overhead and error output when files/directories are missing.
**Action:** Always check file/directory existence using bash built-ins `[ -f ... ]` / `[ -d ... ]`, hoist invariant command calls outside loops, and use bash parameter expansion instead of piping to awk.

## 2026-10-09 - Batch Process Invocation in Shell Scripts
**Learning:** Invoking external commands like `shasum` inside a `while read` loop spawns a subshell process per file (e.g. 50 process forks for 50 files ~1.68s runtime). Collecting matching file paths into a Bash array (`find -print0`) and calling `shasum` once in batch reduces process forks from O(N) to O(1), bringing runtime down to ~0.04s (~38x speedup).
**Action:** Always batch external tool invocations over file lists in shell scripts using Bash arrays or xargs instead of looping per file.
