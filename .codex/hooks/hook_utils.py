from __future__ import annotations

import json
import shutil
import sys
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


def utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def load_event() -> dict[str, Any]:
    try:
        return json.load(sys.stdin)
    except json.JSONDecodeError as exc:
        print(f"Invalid hook JSON input: {exc}", file=sys.stderr)
        raise SystemExit(2)


def repo_root(event: dict[str, Any]) -> Path:
    cwd = event.get("cwd") or "."
    return Path(cwd).resolve()


def ensure_memory_dir(root: Path) -> Path:
    memory_dir = root / ".codex-state"
    memory_dir.mkdir(parents=True, exist_ok=True)
    (memory_dir / "transcript-snapshots").mkdir(parents=True, exist_ok=True)
    return memory_dir


def append_jsonl(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a", encoding="utf-8") as f:
        f.write(json.dumps(payload, ensure_ascii=False, sort_keys=True) + "\n")


def read_text_tail(path: Path, max_chars: int) -> str:
    if not path.exists():
        return ""
    text = path.read_text(encoding="utf-8", errors="replace")
    if len(text) <= max_chars:
        return text
    return text[-max_chars:]


def copy_transcript_if_present(event: dict[str, Any], dst_dir: Path, prefix: str) -> str | None:
    transcript_path = event.get("transcript_path")
    if not transcript_path:
        return None

    src = Path(transcript_path)
    if not src.exists():
        return None

    session_id = str(event.get("session_id", "unknown-session")).replace("/", "_")
    turn_id = str(event.get("turn_id", "no-turn")).replace("/", "_")
    safe_time = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    dst = dst_dir / f"{safe_time}-{session_id}-{turn_id}-{prefix}.jsonl"
    shutil.copy2(src, dst)
    return str(dst)
