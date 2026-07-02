# Codex Compaction Memory Lab — Implementation Status

## Current Status

This repository validates a non-interactive Codex CLI workflow that preserves task continuity through durable project files, lifecycle hooks, JSONL event gates, and explicit validation commands.

## Accepted / Proven

| Area | Status | Evidence |
|---|---:|---|
| Sequenced `codex exec` pipeline | Accepted | `scripts/run_codex_sequence.sh` runs audit → fix → reconcile |
| JSONL run gate | Accepted | `scripts/assert_codex_run_success.sh` checks `turn.completed`, fatal errors, and `FINAL_STATUS: PASS` |
| uv Python 3.10 validation | Accepted | `uv run --python 3.10 pytest` is the canonical test command |
| Durable memory file | Accepted | `.codex-state/LIVE_MEMORY.md` is the authoritative continuity file |
| Stage handoff artifacts | Accepted | `.codex-stage/*.md` records phase outputs and validation evidence |
| Non-interactive progress watcher | Accepted | `scripts/run_codex_watch.sh` + `scripts/watch_codex_jsonl.py` produce TUI-like progress |
| SessionStart hook | Accepted | Hook injects durable memory context at session start |
| UserPromptSubmit hook | Accepted | Hook records submitted prompts and actual model metadata |
| PreCompact/PostCompact local simulation | Accepted | `scripts/simulate_hooks.sh` proves hook scripts work |
| Real PreCompact/PostCompact runtime trigger | Pending | No real runtime compaction has been observed yet |

## Current Defaults

The watcher and sequence wrapper default to:

```text
model: gpt-5.4-mini
reasoning effort: medium
reasoning summary: auto
verbosity: medium
approval policy: never
sandbox: workspace-write
hooks: enabled
```

These can be overridden per run with environment variables:

```bash
CODEX_MODEL=gpt-5.4 \
CODEX_REASONING=high \
CODEX_REASONING_SUMMARY=detailed \
CODEX_VERBOSITY=high \
scripts/run_codex_watch.sh prompts/100-real-compaction-pressure.md
```

## Classification

```text
CODEX_DURABLE_MEMORY_LAB_ACCEPTED
REAL_HOOKS_SESSIONSTART_USERPROMPT_ACCEPTED
NON_INTERACTIVE_PROGRESS_WATCH_ACCEPTED
REAL_COMPACTION_TRIGGER_NOT_REACHED
PRECOMPACT_POSTCOMPACT_REAL_TRIGGER_PENDING
```
