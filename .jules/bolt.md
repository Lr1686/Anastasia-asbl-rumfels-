## 2026-09-30 - Shell Script Process Fork Optimization & Fast-Path Checking
**Learning:** In Bash scripts, spawning external processes like `shasum` on missing target files or piping `shasum` output to `awk` inside loops incurs substantial process fork overhead (e.g., 50+ process creations in 50-item file loops).
**Action:** Use fast-path file existence checks (`[ -f "$TARGET_FILE" ]`) to short-circuit execution when target files do not exist, and use Bash parameter expansion (`${RAW_HASH%% *}`) instead of piping to `awk` to extract hashes without spawning subshells.
