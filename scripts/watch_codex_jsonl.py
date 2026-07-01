#!/usr/bin/env python3
from __future__ import annotations

import json
import sys
from datetime import datetime

def now() -> str:
    return datetime.now().strftime("%H:%M:%S")

def short(text: str, limit: int = 220) -> str:
    text = " ".join(str(text).split())
    return text if len(text) <= limit else text[: limit - 3] + "..."

for line in sys.stdin:
    line = line.strip()
    if not line:
        continue

    try:
        e = json.loads(line)
    except Exception:
        print(f"[{now()}] RAW {short(line)}", flush=True)
        continue

    t = e.get("type")

    if t in {"thread.started", "turn.started", "turn.completed", "turn.failed", "error"}:
        print(f"[{now()}] {t}: {short(e)}", flush=True)
        continue

    item = e.get("item") or {}
    it = item.get("type")
    status = item.get("status")

    if t == "item.started":
        if it == "command_execution":
            print(f"[{now()}] CMD started: {short(item.get('command', ''))}", flush=True)
        elif it == "reasoning":
            print(f"[{now()}] REASONING started", flush=True)
        else:
            print(f"[{now()}] ITEM started: {it or '?'} {status or ''}", flush=True)

    elif t == "item.completed":
        if it == "command_execution":
            cmd = short(item.get("command", ""))
            code = item.get("exit_code")
            output = short(item.get("aggregated_output", ""), 260)
            print(f"[{now()}] CMD done exit={code}: {cmd}", flush=True)
            if output:
                print(f"          output: {output}", flush=True)

        elif it == "agent_message":
            print(f"[{now()}] AGENT: {short(item.get('text', ''), 300)}", flush=True)

        elif it == "file_change":
            print(f"[{now()}] FILE_CHANGE: {short(item)}", flush=True)

        elif it == "error":
            msg = item.get("message", "")
            if "--dangerously-bypass-hook-trust" in msg:
                print(f"[{now()}] WARNING: {short(msg)}", flush=True)
            else:
                print(f"[{now()}] ITEM ERROR: {short(msg)}", flush=True)

        elif it == "reasoning":
            print(f"[{now()}] REASONING done", flush=True)

        else:
            print(f"[{now()}] ITEM done: {it or '?'} {short(item)}", flush=True)

    else:
        print(f"[{now()}] {t}: {short(e)}", flush=True)
