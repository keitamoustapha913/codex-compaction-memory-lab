You are running Part 02: fix and validate.

Before doing anything:
1. Read AGENTS.md.
2. Read .codex-state/LIVE_MEMORY.md.
3. Read .codex-stage/01-audit.md.

Rules:
- Fix the root cause identified in Part 01.
- Keep the fix minimal and correct.
- Do not weaken tests.

Required validation:
- Run: uv run --python 3.10 pytest
- Run: git diff -- src tests

Required artifacts:
- Write .codex-stage/02-fix-and-validate.md with:
  - file changed
  - exact behavior fixed
  - validation command and result
- Update .codex-state/LIVE_MEMORY.md with marker:
  PART_02_FIX_VALIDATED

Final response must end with exactly one of:
FINAL_STATUS: PASS
FINAL_STATUS: FAIL

Print FINAL_STATUS: PASS only if pytest passes, the source fix is present, tests were not weakened, the stage artifact exists, and LIVE_MEMORY.md has the marker.

Protected runtime scratch rule:
- `.codex/memory/` may appear as Codex CLI/tooling scratch.
- Do not read it, write it, delete it, or use it as durable memory.
- Do not fail this stage only because ignored `.codex/memory/` exists.
- Durable memory is `.codex-state/LIVE_MEMORY.md`.
