# Implementation Features

## 1. Durable Memory

Authoritative continuity memory lives at:

```text
.codex-state/LIVE_MEMORY.md
```

Codex is instructed to read this before work, update it after material discoveries, and reconcile it before final status.

`.codex/memory/` is intentionally not used as project memory. It may be created by Codex runtime tooling and must not be treated as durable task state.

## 2. Stage Artifacts

Phase handoff files live under:

```text
.codex-stage/
```

Current major artifacts:

```text
.codex-stage/01-audit.md
.codex-stage/02-fix-and-validate.md
.codex-stage/03-final-reconcile.md
.codex-stage/100-real-compaction-pressure.md
.codex-stage/large-context-payload.md
```

These allow each `codex exec` phase to continue without relying on active chat memory.

## 3. Gated Sequence Runner

Script:

```text
scripts/run_codex_sequence.sh
```

Pipeline:

```text
01-audit-readonly
-> 02-fix-and-validate
-> 03-final-reconcile
-> wrapper-side pytest
-> marker verification
```

Gate rules:

```text
- JSONL must contain turn.completed
- JSONL must not contain fatal turn.failed/error
- final message must contain FINAL_STATUS: PASS
- wrapper-side validation must pass
```

Allowed warning:

```text
--dangerously-bypass-hook-trust
```

This warning is ignored by the gate only because this lab intentionally runs trusted local hook scripts.

## 4. Non-Interactive Watcher

Scripts:

```text
scripts/run_codex_watch.sh
scripts/watch_codex_jsonl.py
scripts/watch_compaction.sh
```

The watcher shows a readable live stream from `codex exec --json`:

```text
thread.started
turn.started
agent progress messages
command started
command completed
file changes
reasoning completions
turn.completed
token usage
final message
compaction summary
snapshot summary
```

Run:

```bash
scripts/run_codex_watch.sh prompts/100-real-compaction-pressure.md
```

Watch only compaction in a second terminal:

```bash
scripts/watch_compaction.sh
```

## 5. Lifecycle Hooks

Hook config:

```text
.codex/hooks.json
```

Hook scripts:

```text
.codex/hooks/session_start_memory_loader.py
.codex/hooks/user_prompt_submit_memory_reminder.py
.codex/hooks/pre_compact_memory_snapshot.py
.codex/hooks/post_compact_marker.py
.codex/hooks/hook_utils.py
```

Hook output paths:

```text
.codex-state/session-start-output.json
.codex-state/prompt-events.jsonl
.codex-state/compaction-events.jsonl
.codex-state/transcript-snapshots/
```

Proven real hooks:

```text
SessionStart
UserPromptSubmit
```

Locally simulated hooks:

```text
PreCompact
PostCompact
```

Real compaction trigger status:

```text
not observed yet
```

## 6. uv Python 3.10

The lab is pinned to Python 3.10:

```text
.python-version
pyproject.toml
uv.lock
```

Canonical validation command:

```bash
uv run --python 3.10 pytest
```

Do not use system `python3 -m pytest` for lab validation.

## 7. Model and Reasoning Defaults

Default watcher/sequence settings:

```text
CODEX_MODEL=gpt-5.4-mini
CODEX_REASONING=medium
CODEX_REASONING_SUMMARY=auto
CODEX_VERBOSITY=medium
```

Override example:

```bash
CODEX_MODEL=gpt-5.4 \
CODEX_REASONING=high \
scripts/run_codex_watch.sh prompts/100-real-compaction-pressure.md
```

Actual model evidence is recorded by `UserPromptSubmit` hook events:

```bash
python3 - <<'PY'
import json
from pathlib import Path

p = Path(".codex-state/prompt-events.jsonl")
for line in p.read_text().splitlines()[-10:]:
    obj = json.loads(line)
    print(obj.get("time_utc"), obj.get("event"), obj.get("model"))
PY
```
