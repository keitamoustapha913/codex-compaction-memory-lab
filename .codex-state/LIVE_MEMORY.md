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
- Memory-stress stage started after re-reading `AGENTS.md` and `.codex-state/LIVE_MEMORY.md`.
- Material discovery: `.codex-stage/99-memory-stress.md` did not exist at stage start.
- Validation result: baseline `git status --short` was clean at memory-stress stage start.
- Created `.codex-stage/99-memory-stress.md` and populated facts 1-20 for the durable-memory stress task.
- Memory-stress checkpoint: completed facts 1-20 in `.codex-stage/99-memory-stress.md`.
- Expanded `.codex-stage/99-memory-stress.md` with facts 21-40.
- Memory-stress checkpoint: completed facts 21-40 in `.codex-stage/99-memory-stress.md`.
- Expanded `.codex-stage/99-memory-stress.md` with facts 41-60.
- Memory-stress checkpoint: completed facts 41-60 in `.codex-stage/99-memory-stress.md`.
- Expanded `.codex-stage/99-memory-stress.md` with facts 61-80.
- Memory-stress checkpoint: completed facts 61-80 in `.codex-stage/99-memory-stress.md`.
- Expanded `.codex-stage/99-memory-stress.md` with facts 81-100.
- Memory-stress checkpoint: completed facts 81-100 in `.codex-stage/99-memory-stress.md`.
- Memory-stress content generation completed; next step is final re-read and command validation.
- Final memory-stress reconciliation re-read `.codex-state/LIVE_MEMORY.md` and `.codex-stage/99-memory-stress.md`.
- Validation result: `wc -l .codex-stage/99-memory-stress.md` returned `102 .codex-stage/99-memory-stress.md`.
- Validation result: final `git status --short` returned ` M .codex-state/LIVE_MEMORY.md`.
- Validation result: `git diff -- .codex-stage/99-memory-stress.md .codex-state/LIVE_MEMORY.md` shows the new durable-memory checkpoint entries; the stage artifact itself does not appear in that diff output.
- Memory-stress stage evidence is sufficient for a PASS result: artifact exists, all five checkpoints exist, required commands were run.
- Real compaction-pressure stage started after re-reading `AGENTS.md` and `.codex-state/LIVE_MEMORY.md`.
- Material discovery: `.codex-stage/large-context-payload.md` exists and `wc -l` reported `14998 .codex-stage/large-context-payload.md`.
- Range checkpoint: verified facts `1-250` in `.codex-stage/large-context-payload.md`; `awk` reported `1-250 250 1 250`. `RANGE_1_250_COMPLETE`
- Range checkpoint: verified facts `251-500` in `.codex-stage/large-context-payload.md`; `awk` reported `251-500 250 251 500`. `RANGE_251_500_COMPLETE`
- Range checkpoint: verified facts `501-750` in `.codex-stage/large-context-payload.md`; `awk` reported `501-750 250 501 750`. `RANGE_501_750_COMPLETE`
- Range checkpoint: verified facts `751-1000` in `.codex-stage/large-context-payload.md`; `awk` reported `751-1000 250 751 1000`. `RANGE_751_1000_COMPLETE`
- Range checkpoint: verified facts `1001-1250` in `.codex-stage/large-context-payload.md`; `awk` reported `1001-1250 250 1001 1250`. `RANGE_1001_1250_COMPLETE`
- Range checkpoint: verified facts `1251-1500` in `.codex-stage/large-context-payload.md`; `awk` reported `1251-1500 250 1251 1500`. `RANGE_1251_1500_COMPLETE`
- Range checkpoint: verified facts `1501-1750` in `.codex-stage/large-context-payload.md`; `awk` reported `1501-1750 250 1501 1750`. `RANGE_1501_1750_COMPLETE`
- Range checkpoint: verified facts `1751-2000` in `.codex-stage/large-context-payload.md`; `awk` reported `1751-2000 250 1751 2000`. `RANGE_1751_2000_COMPLETE`
- Range checkpoint: verified facts `2001-2250` in `.codex-stage/large-context-payload.md`; `awk` reported `2001-2250 250 2001 2250`. `RANGE_2001_2250_COMPLETE`
- Range checkpoint: verified facts `2251-2500` in `.codex-stage/large-context-payload.md`; `awk` reported `2251-2500 250 2251 2500`. `RANGE_2251_2500_COMPLETE`
- Material discovery: `.codex-state/compaction-events.jsonl` is missing and `.codex-state/transcript-snapshots` exists during the real compaction-pressure stage.
- Created `.codex-stage/100-real-compaction-pressure.md` with processed ranges, hook artifact status, and validation evidence placeholders.
- Validation result: `test -f .codex-stage/100-real-compaction-pressure.md` returned exit code `0`.
- Validation result: `grep -q 'RANGE_2001_2250_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result: `grep -q 'RANGE_2251_2500_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result: `git status --short` showed modified `.codex-state/LIVE_MEMORY.md` and unrelated untracked `prompts/100-real-compaction-pressure.md`.
- Validation result: `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md` shows the expected real compaction-pressure stage updates.
- Real compaction-pressure stage reached final reconciliation pending re-read of the stage artifact, `LIVE_MEMORY.md`, and git evidence.
- Final real compaction-pressure reconciliation re-read `.codex-stage/100-real-compaction-pressure.md`, `LIVE_MEMORY.md`, `git status --short`, and `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md`; the processed ranges, final markers, artifact existence, and validation evidence are consistent for a PASS result.
- Real compaction-pressure rerun started on 2026-07-01 after re-reading `AGENTS.md`, `.codex-state/LIVE_MEMORY.md`, and scanning `.codex-stage/large-context-payload.md` completely.
- Material discovery in the rerun: `.codex-stage/large-context-payload.md` structure is `## Fact Block N` and `wc -l` remains `14998 .codex-stage/large-context-payload.md`.
- Rerun range checkpoint: verified facts `1-250` by full-file `awk` scan with result `1-250 250 1 250`. `RANGE_1_250_COMPLETE`
- Rerun range checkpoint: verified facts `251-500` by full-file `awk` scan with result `251-500 250 251 500`. `RANGE_251_500_COMPLETE`
- Rerun range checkpoint: verified facts `501-750` by full-file `awk` scan with result `501-750 250 501 750`. `RANGE_501_750_COMPLETE`
- Rerun range checkpoint: verified facts `751-1000` by full-file `awk` scan with result `751-1000 250 751 1000`. `RANGE_751_1000_COMPLETE`
- Rerun range checkpoint: verified facts `1001-1250` by full-file `awk` scan with result `1001-1250 250 1001 1250`. `RANGE_1001_1250_COMPLETE`
- Rerun range checkpoint: verified facts `1251-1500` by full-file `awk` scan with result `1251-1500 250 1251 1500`. `RANGE_1251_1500_COMPLETE`
- Rerun range checkpoint: verified facts `1501-1750` by full-file `awk` scan with result `1501-1750 250 1501 1750`. `RANGE_1501_1750_COMPLETE`
- Rerun range checkpoint: verified facts `1751-2000` by full-file `awk` scan with result `1751-2000 250 1751 2000`. `RANGE_1751_2000_COMPLETE`
- Rerun range checkpoint: verified facts `2001-2250` by full-file `awk` scan with result `2001-2250 250 2001 2250`. `RANGE_2001_2250_COMPLETE`
- Rerun range checkpoint: verified facts `2251-2500` by full-file `awk` scan with result `2251-2500 250 2251 2500`. `RANGE_2251_2500_COMPLETE`
- Material discovery in the rerun: `.codex-state/compaction-events.jsonl` is missing and `.codex-state/transcript-snapshots` exists.
- Validation result in the rerun: `test -f .codex-stage/100-real-compaction-pressure.md` returned exit code `0`.
- Validation result in the rerun: `grep -q 'RANGE_2001_2250_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result in the rerun: `grep -q 'RANGE_2251_2500_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result in the rerun: `git status --short` returned clean output.
- Validation result in the rerun: `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md` returned no diff before the rerun artifact refresh.
- Real compaction-pressure rerun reached artifact-refresh phase; next step is updating `.codex-stage/100-real-compaction-pressure.md` with this run's evidence.
- Final rerun reconciliation re-read `.codex-stage/100-real-compaction-pressure.md` and the tail of `LIVE_MEMORY.md`, then re-ran the required validations.
- Final rerun validation result: `test -f .codex-stage/100-real-compaction-pressure.md` returned exit code `0`.
- Final rerun validation result: `grep -q 'RANGE_2001_2250_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Final rerun validation result: `grep -q 'RANGE_2251_2500_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Final rerun validation result: `git status --short` showed only `M .codex-state/LIVE_MEMORY.md`.
- Final rerun validation result: `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md` shows only the appended rerun entries in `LIVE_MEMORY.md`; the stage artifact contents are already reconciled.
- Final real compaction-pressure rerun reconciliation confirms that all 10 ranges were processed, both final range markers are present in `LIVE_MEMORY.md`, and `.codex-stage/100-real-compaction-pressure.md` exists; PASS is proven for this prompt.
- Real compaction-pressure current run started on 2026-07-01 after re-reading `AGENTS.md`, `.codex-state/LIVE_MEMORY.md`, and `.codex-stage/large-context-payload.md` completely.
- Material discovery in the current run: `.codex-stage/large-context-payload.md` was fully re-scanned across lines `1-14998`; payload structure remains repeated `## Fact Block N` sections with `UNIQUE_FACT`, `EXPECTED_CHECKPOINT`, and `TRACE` lines through fact `2500`.
- Current-run range checkpoint: verified facts `1-250` with full-file `awk` result `1-250 250 1 250`. `RANGE_1_250_COMPLETE`
- Current-run range checkpoint: verified facts `251-500` with full-file `awk` result `251-500 250 251 500`. `RANGE_251_500_COMPLETE`
- Current-run range checkpoint: verified facts `501-750` with full-file `awk` result `501-750 250 501 750`. `RANGE_501_750_COMPLETE`
- Current-run range checkpoint: verified facts `751-1000` with full-file `awk` result `751-1000 250 751 1000`. `RANGE_751_1000_COMPLETE`
- Current-run range checkpoint: verified facts `1001-1250` with full-file `awk` result `1001-1250 250 1001 1250`. `RANGE_1001_1250_COMPLETE`
- Current-run range checkpoint: verified facts `1251-1500` with full-file `awk` result `1251-1500 250 1251 1500`. `RANGE_1251_1500_COMPLETE`
- Current-run range checkpoint: verified facts `1501-1750` with full-file `awk` result `1501-1750 250 1501 1750`. `RANGE_1501_1750_COMPLETE`
- Current-run range checkpoint: verified facts `1751-2000` with full-file `awk` result `1751-2000 250 1751 2000`. `RANGE_1751_2000_COMPLETE`
- Current-run range checkpoint: verified facts `2001-2250` with full-file `awk` result `2001-2250 250 2001 2250`. `RANGE_2001_2250_COMPLETE`
- Current-run range checkpoint: verified facts `2251-2500` with full-file `awk` result `2251-2500 250 2251 2500`. `RANGE_2251_2500_COMPLETE`
- Material discovery in the current run: `.codex-state/compaction-events.jsonl` exists as an empty file and `.codex-state/transcript-snapshots` exists as a directory; this corrects the stale missing-file note from earlier runs.
- Validation result in the current run: `test -f .codex-stage/100-real-compaction-pressure.md` returned exit code `0`.
- Validation result in the current run: `grep -q 'RANGE_2001_2250_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result in the current run: `grep -q 'RANGE_2251_2500_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result in the current run: `git status --short` showed `M .codex-state/LIVE_MEMORY.md` plus unrelated untracked `scripts/run_codex_watch.sh` and `scripts/watch_codex_jsonl.py`.
- Validation result in the current run: `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md` shows the appended current-run durable-memory entries and the stage-artifact refresh.
- Final current-run reconciliation re-read `.codex-stage/100-real-compaction-pressure.md`, the tail of `LIVE_MEMORY.md`, `git status --short`, and the diff for `.codex-stage/100-real-compaction-pressure.md` plus `.codex-state/LIVE_MEMORY.md`; all 10 ranges, both final markers, artifact existence, and current hook-status evidence are consistent for a PASS result.
- Real compaction-pressure verification rerun started on 2026-07-01 after re-reading `AGENTS.md`, `.codex-state/LIVE_MEMORY.md`, and `.codex-stage/large-context-payload.md` completely.
- Material discovery in the verification rerun: `.codex-stage/large-context-payload.md` remains `14998` lines long and the required 10 ranges are being re-validated against `## Fact Block N` markers.
- Verification-rerun range checkpoint: verified facts `1-250` with full-file `awk` result `1-250 250 1 250`. `RANGE_1_250_COMPLETE`
- Verification-rerun range checkpoint: verified facts `251-500` with full-file `awk` result `251-500 250 251 500`. `RANGE_251_500_COMPLETE`
- Verification-rerun range checkpoint: verified facts `501-750` with full-file `awk` result `501-750 250 501 750`. `RANGE_501_750_COMPLETE`
- Verification-rerun range checkpoint: verified facts `751-1000` with full-file `awk` result `751-1000 250 751 1000`. `RANGE_751_1000_COMPLETE`
- Verification-rerun range checkpoint: verified facts `1001-1250` with full-file `awk` result `1001-1250 250 1001 1250`. `RANGE_1001_1250_COMPLETE`
- Verification-rerun range checkpoint: verified facts `1251-1500` with full-file `awk` result `1251-1500 250 1251 1500`. `RANGE_1251_1500_COMPLETE`
- Verification-rerun range checkpoint: verified facts `1501-1750` with full-file `awk` result `1501-1750 250 1501 1750`. `RANGE_1501_1750_COMPLETE`
- Verification-rerun range checkpoint: verified facts `1751-2000` with full-file `awk` result `1751-2000 250 1751 2000`. `RANGE_1751_2000_COMPLETE`
- Verification-rerun range checkpoint: verified facts `2001-2250` with full-file `awk` result `2001-2250 250 2001 2250`. `RANGE_2001_2250_COMPLETE`
- Verification-rerun range checkpoint: verified facts `2251-2500` with full-file `awk` result `2251-2500 250 2251 2500`. `RANGE_2251_2500_COMPLETE`
- Material discovery in the verification rerun: `.codex-state/compaction-events.jsonl` is currently missing, so compaction is not observed; `.codex-state/transcript-snapshots` exists as an empty directory and does not prove compaction.
- Validation result in the verification rerun: `test -f .codex-stage/100-real-compaction-pressure.md` returned exit code `0`.
- Validation result in the verification rerun: `grep -q 'RANGE_2001_2250_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result in the verification rerun: `grep -q 'RANGE_2251_2500_COMPLETE' .codex-state/LIVE_MEMORY.md` returned exit code `0`.
- Validation result in the verification rerun: `git status --short` showed `M .codex-state/LIVE_MEMORY.md`, `M prompts/100-real-compaction-pressure.md`, and unrelated untracked `scripts/run_codex_watch.sh`, `scripts/watch_codex_jsonl.py`, `scripts/watch_compaction.sh`.
- Validation result in the verification rerun: `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md` showed the appended verification-rerun entries in `LIVE_MEMORY.md` and the stage-artifact refresh.
- Verification rerun reached final reconciliation pending re-read of `.codex-stage/100-real-compaction-pressure.md`, `LIVE_MEMORY.md`, and current git evidence.
- Final verification-rerun reconciliation re-read `.codex-stage/100-real-compaction-pressure.md`, the tail of `LIVE_MEMORY.md`, `git status --short`, and `git diff -- .codex-stage/100-real-compaction-pressure.md .codex-state/LIVE_MEMORY.md`; all 10 ranges were processed, both final markers are present, the stage artifact exists, and current hook evidence correctly records that compaction is not observed.
