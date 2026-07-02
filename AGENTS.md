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

## Protected Codex runtime scratch

`.codex/memory/` may be created by Codex CLI/runtime tooling. It is not the durable memory file for this experiment.

Rules:
- Do not use `.codex/memory/` as task memory.
- Do not try to delete `.codex/memory/` from inside Codex.
- Do not treat ignored `.codex/memory/` contents as task failure.
- The only authoritative durable memory is `.codex-state/LIVE_MEMORY.md`.

<!-- CURRENT_LAB_RULES_START -->
## Current Lab Rules

- Use `.codex-state/LIVE_MEMORY.md` as the authoritative durable memory file.
- Do not use `.codex/memory/` as project memory.
- Do not fail a task merely because ignored `.codex/memory/` scratch exists.
- Use `uv run --python 3.10 pytest` for validation.
- Default non-interactive model is `gpt-5.4-mini`.
- Default reasoning effort is `medium`.
- Use `scripts/run_codex_sequence.sh` for gated multi-part execution.
- Use `scripts/run_codex_watch.sh` for TUI-like non-interactive progress.
- Use `scripts/watch_compaction.sh` to watch for real PreCompact/PostCompact events.
- Treat compaction as observed only when `.codex-state/compaction-events.jsonl` is non-empty and contains `PreCompact` or `PostCompact`.
- End every Codex task with exactly one final status line: `FINAL_STATUS: PASS` or `FINAL_STATUS: FAIL`.
<!-- CURRENT_LAB_RULES_END -->
