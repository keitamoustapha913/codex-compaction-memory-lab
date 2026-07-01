#!/usr/bin/env bash
set -euo pipefail

EVENTS="${1:?events jsonl required}"
FINAL="${2:?final message file required}"

python3 - "$EVENTS" "$FINAL" <<'PY'
from __future__ import annotations

import json
import sys
from pathlib import Path

events_path = Path(sys.argv[1])
final_path = Path(sys.argv[2])

allowed_warning_fragments = [
    "--dangerously-bypass-hook-trust",
    "Enabled hooks may run without review",
]

saw_turn_completed = False
fatal_events = []
warnings = []

for line_no, line in enumerate(events_path.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
    if not line.strip():
        continue

    try:
        event = json.loads(line)
    except json.JSONDecodeError as exc:
        fatal_events.append((line_no, f"invalid json: {exc}", line))
        continue

    event_type = event.get("type")

    if event_type == "turn.completed":
        saw_turn_completed = True
        continue

    if event_type in {"turn.failed", "error"}:
        fatal_events.append((line_no, f"top-level {event_type}", line))
        continue

    item = event.get("item")
    if isinstance(item, dict) and item.get("type") == "error":
        msg = str(item.get("message", ""))
        if any(fragment in msg for fragment in allowed_warning_fragments):
            warnings.append((line_no, msg))
        else:
            fatal_events.append((line_no, "item error", line))

if not saw_turn_completed:
    print(f"CODEX FAILED: no turn.completed found in {events_path}", file=sys.stderr)
    sys.exit(1)

if fatal_events:
    print(f"CODEX FAILED: fatal event/error found in {events_path}", file=sys.stderr)
    for line_no, reason, raw in fatal_events[:20]:
        print(f"{line_no}: {reason}: {raw}", file=sys.stderr)
    sys.exit(1)

if not final_path.exists():
    print(f"CODEX FAILED: final message file missing: {final_path}", file=sys.stderr)
    sys.exit(1)

final_text = final_path.read_text(encoding="utf-8", errors="replace")

if "FINAL_STATUS: PASS" not in final_text:
    print(f"CODEX FINISHED BUT DID NOT PROVE SUCCESS: {final_path}", file=sys.stderr)
    print(final_text, file=sys.stderr)
    sys.exit(1)

if warnings:
    print(f"CODEX_RUN_GATE: ignored {len(warnings)} allowed warning(s)")

print("CODEX_RUN_GATE: PASS")
PY
