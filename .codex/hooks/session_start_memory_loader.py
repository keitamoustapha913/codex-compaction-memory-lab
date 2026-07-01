#!/usr/bin/env python3
from __future__ import annotations

import json
from pathlib import Path

from hook_utils import ensure_memory_dir, load_event, read_text_tail, repo_root

MAX_MEMORY_CHARS = 16000
MAX_EVENTS_CHARS = 4000


def main() -> int:
    event = load_event()
    root = repo_root(event)
    memory_dir = ensure_memory_dir(root)

    live_memory_path = memory_dir / "LIVE_MEMORY.md"
    compaction_events_path = memory_dir / "compaction-events.jsonl"
    prompt_events_path = memory_dir / "prompt-events.jsonl"

    live_memory = read_text_tail(live_memory_path, MAX_MEMORY_CHARS)
    compaction_events = read_text_tail(compaction_events_path, MAX_EVENTS_CHARS)
    prompt_events = read_text_tail(prompt_events_path, MAX_EVENTS_CHARS)

    source = event.get("source", "unknown")
    additional_context = f"""
Durable Codex memory hook loaded.

SessionStart source: {source}

Authoritative continuity file:
.codex/memory/LIVE_MEMORY.md

Rules:
1. Read .codex/memory/LIVE_MEMORY.md before acting.
2. Update .codex/memory/LIVE_MEMORY.md after material discoveries, patches, validations, blockers, and phase transitions.
3. If this start source is `compact`, treat LIVE_MEMORY.md plus repository evidence as the recovery source after compaction.
4. Before final output, reconcile LIVE_MEMORY.md with git status, git diff, and validation logs.
5. Report FINAL_STATUS: PASS only when fully proven.

===== LIVE_MEMORY.md tail =====
{live_memory or "<no live memory yet>"}

===== compaction-events.jsonl tail =====
{compaction_events or "<no compaction events yet>"}

===== prompt-events.jsonl tail =====
{prompt_events or "<no prompt events yet>"}
""".strip()

    output = {
        "hookSpecificOutput": {
            "hookEventName": "SessionStart",
            "additionalContext": additional_context,
        }
    }

    # Save the exact output for local inspection during tests.
    (memory_dir / "session-start-output.json").write_text(
        json.dumps(output, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(json.dumps(output, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
