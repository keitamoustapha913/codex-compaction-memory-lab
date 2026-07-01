# LIVE_MEMORY.md

This is the durable continuity memory for the Codex Compaction Memory Lab.

## Non-negotiable objective

Test whether a Codex CLI non-interactive workflow can preserve enough task continuity through durable files and lifecycle hooks so that compaction does not destroy the working plan.

## Current phase

Not started.

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
