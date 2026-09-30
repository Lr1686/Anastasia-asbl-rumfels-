## 2026-04-19 - Fast-path File Checks and Native String Manipulation in Shell Scripts
**Learning:** Shell scripts checking target files via external tools like `shasum | awk` incur process fork overhead even when target files are missing. Unquoted paths with spaces cause errors and extra failed process forks.
**Action:** Always check file existence using Bash built-in `[ -f "$FILE" ]` before spawning hash tools, quote paths properly, and use Bash parameter expansion `${HASH%% *}` to avoid `awk` process forks.
