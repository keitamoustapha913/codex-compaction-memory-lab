# LIVE_MEMORY.md

This is the durable continuity memory for the Codex Compaction Memory Lab.

## Non-negotiable objective

Test whether a Codex CLI non-interactive workflow can preserve enough task continuity through durable files and lifecycle hooks so that compaction does not destroy the working plan.

## Current phase

Part 03 final reconciliation completed.

## Required stage markers

Codex should add these markers as it completes each real `codex exec` stage:

- `PART_01_AUDIT_COMPLETE`
- `PART_02_FIX_VALIDATED`
- `PART_03_FINAL_RECONCILED`

## Validation policy

Codex may print `FINAL_STATUS: PASS` only if the active stage's required files and validation commands are complete and proven.

## Running facts

- The source file `src/codex_memory_lab/calculator.py` intentionally contains a bug at repo creation time.
- The tests in `tests/test_calculator.py` define the expected behavior.
- The sequence wrapper checks Codex JSONL events and the final message for `FINAL_STATUS: PASS`.
- Part 01 audit found that `safe_divide()` returns `0.0` when `denominator == 0` in `src/codex_memory_lab/calculator.py`.
- `tests/test_calculator.py` expects `safe_divide(10, 0)` to raise `ZeroDivisionError`.
- The exact validation command required in Part 02 is `uv run --python 3.10 pytest`.
- Baseline `git status --short` before Part 01 artifact edits showed unrelated existing modifications in `scripts/assert_codex_run_success.sh` and `scripts/run_codex_sequence.sh`.
- Created `.codex-stage/01-audit.md` with the observed bug, affected file, expected test behavior, and Part 02 validation command.
- PART_01_AUDIT_COMPLETE
- Part 02 started after re-reading `AGENTS.md`, `.codex-state/LIVE_MEMORY.md`, and `.codex-stage/01-audit.md`.
- Reconfirmed from source and tests that `src/codex_memory_lab/calculator.py` returns `0.0` for zero denominator while `tests/test_calculator.py` requires `ZeroDivisionError`.
- Updated `src/codex_memory_lab/calculator.py` to remove the incorrect zero-denominator fallback so `safe_divide()` now uses direct division and raises `ZeroDivisionError` on zero denominator.
- Validation result: `uv run --python 3.10 pytest` passed with `2 passed in 0.01s`.
- Validation result: `git diff -- src tests` shows only the intended change in `src/codex_memory_lab/calculator.py`; `tests/test_calculator.py` was not modified.
- Created `.codex-stage/02-fix-and-validate.md` with the changed file, exact fixed behavior, and validation results.
- PART_02_FIX_VALIDATED
- Final Part 02 reconciliation re-read `.codex-stage/02-fix-and-validate.md`, `git status --short`, `git diff -- src tests`, and `LIVE_MEMORY.md`; required evidence is consistent for a PASS result.
- Part 03 started after re-reading `AGENTS.md`, `.codex-state/LIVE_MEMORY.md`, `.codex-stage/01-audit.md`, and `.codex-stage/02-fix-and-validate.md`.
- Part 03 initial reconciliation confirms the stage artifacts and durable memory agree on the root cause, minimal fix, and required final validations.
- Validation result: `uv run --python 3.10 pytest` passed in Part 03 with `2 passed in 0.01s`.
- Validation result: `git status --short` in Part 03 shows modified `.codex-state/LIVE_MEMORY.md`, `src/codex_memory_lab/calculator.py`, and the pre-existing unrelated script changes in `scripts/assert_codex_run_success.sh` and `scripts/run_codex_sequence.sh`.
- Validation result: `git diff -- src tests .codex-stage .codex-state/LIVE_MEMORY.md` shows the intended calculator fix and durable-memory updates; no `tests/` changes are present, and the `.codex-stage/` artifacts are not reported by that `git diff` output.
- Hook log discovery in Part 03 found no repository files matching `prompt-events.jsonl` or `compaction-events.jsonl`; prompt and compaction tails were available from the injected runtime context instead.
- Created `.codex-stage/03-final-reconcile.md` with final validation results, hook-log status, changed-file list, and proof assessment.
- PART_03_FINAL_RECONCILED
- Final Part 03 reconciliation re-read all stage artifacts, `git status --short`, `git diff -- src tests .codex-stage .codex-state/LIVE_MEMORY.md`, and `LIVE_MEMORY.md`; required evidence is consistent for a PASS result.
