## 2026-09-04 - Batch Shell Process Execution
**Learning:** Invoking `shasum` and `awk` sequentially inside a `while read` loop for file scanning spawns separate child processes for every file (N shasum + N awk + N date forks), taking ~1650ms for 50 files. Batching file paths into `xargs shasum -a 256` and evaluating date once reduces execution time to ~60ms (~27x speedup / 96% time saved).
**Action:** Prefer batching file operations with `xargs` or array expansion over per-iteration loops in shell scripts.
