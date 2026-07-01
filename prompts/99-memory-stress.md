You are running a manual memory-stress task for the Codex Compaction Memory Lab.

Before doing anything:
1. Read AGENTS.md.
2. Read .codex-state/LIVE_MEMORY.md.

Task:
- Create or update .codex-stage/99-memory-stress.md.
- Add 100 numbered facts to that file, where each fact is unique and references the durable-memory experiment.
- After every 20 facts, update .codex-state/LIVE_MEMORY.md with a compact checkpoint saying which range was completed.
- After all 100 facts, re-read .codex-state/LIVE_MEMORY.md and .codex-stage/99-memory-stress.md.
- Run: wc -l .codex-stage/99-memory-stress.md
- Run: git status --short

Purpose:
This is meant to increase context pressure and exercise the hooks. It may or may not trigger actual automatic compaction depending on model/context size and Codex internals.

Final response must end with exactly one of:
FINAL_STATUS: PASS
FINAL_STATUS: FAIL

Print FINAL_STATUS: PASS only if the stress artifact exists, the memory checkpoints exist, and commands were run.
