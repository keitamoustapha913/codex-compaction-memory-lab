#!/usr/bin/env python3
from __future__ import annotations

import json

from hook_utils import append_jsonl, ensure_memory_dir, load_event, repo_root, utc_now


def main() -> int:
    event = load_event()
    root = repo_root(event)
    memory_dir = ensure_memory_dir(root)

    prompt = event.get("prompt", "")
    marker = {
        "time_utc": utc_now(),
        "event": "UserPromptSubmit",
        "session_id": event.get("session_id"),
        "turn_id": event.get("turn_id"),
        "model": event.get("model"),
        "prompt_preview": prompt[:500],
    }
    append_jsonl(memory_dir / "prompt-events.jsonl", marker)

    reminder = {
        "hookSpecificOutput": {
            "hookEventName": "UserPromptSubmit",
            "additionalContext": (
                "Durable-memory reminder: keep .codex/memory/LIVE_MEMORY.md current. "
                "After each material discovery, file change, validation result, blocker, or phase transition, "
                "update LIVE_MEMORY.md so the run can recover after compaction."
            ),
        }
    }
    print(json.dumps(reminder, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
