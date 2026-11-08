## 2026-10-07 - Shell Script Subshell Overhead & Fast-Path Checks
**Learning:** In gatekeeper.sh and deep_research_local.sh, invoking external commands (shasum, awk, date) inside loops or without fast-path file/directory existence checks causes significant subshell fork overhead and error output when files/directories are missing.
**Action:** Always check file/directory existence using bash built-ins `[ -f ... ]` / `[ -d ... ]`, hoist invariant command calls outside loops, and use bash parameter expansion instead of piping to awk.

## 2026-10-12 - Batch External Process Execution in Shell Loops
**Learning:** Invoking external commands like `shasum` inside a loop for each file incurs high process fork and exec overhead (30+ ms per fork), leading to slow script execution when scanning multiple files.
**Action:** Collect file paths into a Bash array using null-delimited find (`find ... -print0`) and pass the entire array to `shasum` in a single invocation, guarded by `[ "${#files[@]}" -gt 0 ]`.
