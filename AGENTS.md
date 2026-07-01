# AGENTS.md

This repository is a Codex CLI experiment for durable memory and compaction hooks.

Non-negotiable rules for Codex:

1. Before starting any task, read `.codex-state/LIVE_MEMORY.md` if it exists.
2. Treat `.codex-state/LIVE_MEMORY.md` as durable continuity memory.
3. Update `.codex-state/LIVE_MEMORY.md` after every material discovery, file change, validation result, blocker, and phase transition.
4. Do not report `FINAL_STATUS: PASS` unless all validation required by the active prompt passed.
5. If validation was skipped, unavailable, ambiguous, or not proven, report `FINAL_STATUS: FAIL`.
6. Before the final answer, re-read the relevant stage artifacts, git diff/status, validation output, and `LIVE_MEMORY.md`.

Expected final line for each prompt:

```text
FINAL_STATUS: PASS
```

or

```text
FINAL_STATUS: FAIL
```
