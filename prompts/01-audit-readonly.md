You are running Part 01: read-only audit.

Before doing anything:
1. Read AGENTS.md.
2. Read .codex-state/LIVE_MEMORY.md.

Rules:
- Do not modify source code or tests.
- You may create/update only:
  - .codex-stage/01-audit.md
  - .codex-state/LIVE_MEMORY.md
- Inspect the repository and identify the deliberately broken behavior.
- Do not implement the fix in this part.

Required validation:
- Run: git status --short
- Confirm no source or test files were modified by this part.

Required artifacts:
- Write .codex-stage/01-audit.md with:
  - observed bug
  - affected file
  - expected behavior from tests
  - exact validation command needed in Part 02
- Update .codex-state/LIVE_MEMORY.md with marker:
  PART_01_AUDIT_COMPLETE

Final response must end with exactly one of:
FINAL_STATUS: PASS
FINAL_STATUS: FAIL

Print FINAL_STATUS: PASS only if the audit artifact exists, LIVE_MEMORY.md has the marker, and the read-only rule is satisfied.
