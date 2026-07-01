You are running Part 03: final reconcile.

Before doing anything:
1. Read AGENTS.md.
2. Read .codex-state/LIVE_MEMORY.md.
3. Read .codex-stage/01-audit.md.
4. Read .codex-stage/02-fix-and-validate.md.

Rules:
- Do not make more source changes unless validation proves the fix is still broken.
- Reconcile durable memory, stage artifacts, git status, git diff, and tests.

Required validation:
- Run: uv run --python 3.10 pytest
- Run: git status --short
- Run: git diff -- src tests .codex-stage .codex-state/LIVE_MEMORY.md

Required artifacts:
- Write .codex-stage/03-final-reconcile.md with:
  - final validation result
  - whether hooks produced prompt or compaction logs if any exist
  - final list of changed files
  - whether success is proven or not proven
- Update .codex-state/LIVE_MEMORY.md with marker:
  PART_03_FINAL_RECONCILED

Final response must end with exactly one of:
FINAL_STATUS: PASS
FINAL_STATUS: FAIL

Print FINAL_STATUS: PASS only if pytest passes, required stage artifacts exist, LIVE_MEMORY.md has all three part markers, and no unproven validation remains.

Protected runtime scratch rule:
- `.codex/memory/` may appear as Codex CLI/tooling scratch.
- Do not read it, write it, delete it, or use it as durable memory.
- Do not fail this stage only because ignored `.codex/memory/` exists.
- Durable memory is `.codex-state/LIVE_MEMORY.md`.
