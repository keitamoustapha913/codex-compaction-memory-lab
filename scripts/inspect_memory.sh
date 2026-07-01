#!/usr/bin/env bash
set -euo pipefail

find .codex/memory -maxdepth 3 -type f -print | sort

echo
if [[ -f .codex/memory/LIVE_MEMORY.md ]]; then
  echo "===== LIVE_MEMORY.md ====="
  cat .codex/memory/LIVE_MEMORY.md
fi

echo
if [[ -f .codex/memory/compaction-events.jsonl ]]; then
  echo "===== compaction-events.jsonl ====="
  cat .codex/memory/compaction-events.jsonl
fi

echo
if [[ -f .codex/memory/prompt-events.jsonl ]]; then
  echo "===== prompt-events.jsonl ====="
  cat .codex/memory/prompt-events.jsonl
fi
