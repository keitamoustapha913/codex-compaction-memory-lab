# Runbook

## 1. Verify Local Hook Simulation

```bash
./scripts/simulate_hooks.sh
```

Expected:

```text
LOCAL_HOOK_SIMULATION: PASS
```

This proves the hook scripts can write:

```text
.codex-state/compaction-events.jsonl
.codex-state/prompt-events.jsonl
.codex-state/session-start-output.json
.codex-state/transcript-snapshots/
```

## 2. Run the Full Gated Sequence

```bash
CODEX_BYPASS_HOOK_TRUST=1 ./scripts/run_codex_sequence.sh
```

Expected:

```text
=== Running 01-audit-readonly ===
CODEX_RUN_GATE: PASS
=== Running 02-fix-and-validate ===
CODEX_RUN_GATE: PASS
=== Running 03-final-reconcile ===
CODEX_RUN_GATE: PASS
ALL_CODEX_SEQUENCE_PARTS: PASS
```

## 3. Run with Live Non-Interactive Progress

```bash
scripts/run_codex_watch.sh prompts/100-real-compaction-pressure.md
```

The runner prints:

```text
RUN_ID
MODEL
REASONING
REASONING_SUMMARY
VERBOSITY
EVENTS path
STDERR path
FINAL path
```

It then streams readable progress from Codex JSONL events.

## 4. Watch for Compaction in Another Terminal

```bash
scripts/watch_compaction.sh
```

Real compaction is proven only when:

```bash
[[ -s .codex-state/compaction-events.jsonl ]] \
  && grep -Eq 'PreCompact|PostCompact' .codex-state/compaction-events.jsonl
```

If that condition is false, report:

```text
NO_REAL_COMPACTION_OBSERVED
```

## 5. Inspect Latest Run

```bash
ls -ltr .codex-runs | tail
cat .codex-runs/<RUN_ID>-final.md
tail -n 40 .codex-runs/<RUN_ID>-events.jsonl
cat .codex-runs/<RUN_ID>-stderr.log
```

## 6. Inspect Hook Evidence

```bash
find .codex-state -maxdepth 3 -type f -print | sort

cat .codex-state/prompt-events.jsonl 2>/dev/null || true
cat .codex-state/session-start-output.json 2>/dev/null || true
cat .codex-state/compaction-events.jsonl 2>/dev/null || true
find .codex-state/transcript-snapshots -type f -print 2>/dev/null | sort || true
```

## 7. Confirm Model Used

```bash
python3 - <<'PY'
import json
from pathlib import Path

p = Path(".codex-state/prompt-events.jsonl")
if not p.exists():
    print("NO_PROMPT_EVENTS_FILE")
    raise SystemExit(0)

for line in p.read_text().splitlines()[-10:]:
    if not line.strip():
        continue
    obj = json.loads(line)
    print(obj.get("time_utc"), obj.get("event"), obj.get("model"))
PY
```

Expected default:

```text
gpt-5.4-mini
```

## 8. Override Model and Reasoning

```bash
CODEX_MODEL=gpt-5.4 \
CODEX_REASONING=high \
CODEX_REASONING_SUMMARY=detailed \
CODEX_VERBOSITY=high \
scripts/run_codex_watch.sh prompts/100-real-compaction-pressure.md
```

## 9. Reset Runtime Artifacts

Use this before clean reruns:

```bash
rm -rf .codex-runs
rm -f .codex-state/prompt-events.jsonl
rm -f .codex-state/session-start-output.json
rm -f .codex-state/compaction-events.jsonl
rm -rf .codex-state/transcript-snapshots
rm -rf .codex/memory
```

Do not delete `.codex-state/LIVE_MEMORY.md` unless intentionally resetting durable memory.
