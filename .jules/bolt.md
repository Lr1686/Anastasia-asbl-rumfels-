## 2026-10-07 - Shell Script Subshell Overhead & Fast-Path Checks
**Learning:** In gatekeeper.sh and deep_research_local.sh, invoking external commands (shasum, awk, date) inside loops or without fast-path file/directory existence checks causes significant subshell fork overhead and error output when files/directories are missing.
**Action:** Always check file/directory existence using bash built-ins `[ -f ... ]` / `[ -d ... ]`, hoist invariant command calls outside loops, and use bash parameter expansion instead of piping to awk.

## 2026-10-08 - Batching File Hashing to Eliminate Loop Process Forks
**Learning:** Running `shasum` repeatedly inside a `while read` loop incurs massive process fork overhead (~1.66s for 50 files). Collecting target files into a Bash array via null-terminated `find -print0` and executing `shasum` once on all files reduces execution time to ~0.04s (~40x speedup).
**Action:** Collect file lists into Bash arrays using `IFS= read -r -d ''` and pass all arguments in a single `shasum` invocation instead of spawning individual processes per file in a loop.
