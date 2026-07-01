#!/usr/bin/env python3
from __future__ import annotations

import json

from hook_utils import append_jsonl, copy_transcript_if_present, ensure_memory_dir, load_event, repo_root, utc_now


def main() -> int:
    event = load_event()
    root = repo_root(event)
    memory_dir = ensure_memory_dir(root)

    snapshot_path = copy_transcript_if_present(
        event,
        memory_dir / "transcript-snapshots",
        prefix="postcompact",
    )

    marker = {
        "time_utc": utc_now(),
        "event": "PostCompact",
        "trigger": event.get("trigger"),
        "session_id": event.get("session_id"),
        "turn_id": event.get("turn_id"),
        "model": event.get("model"),
        "transcript_path": event.get("transcript_path"),
        "snapshot_path": snapshot_path,
    }
    append_jsonl(memory_dir / "compaction-events.jsonl", marker)
    print(json.dumps({"continue": True}, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
