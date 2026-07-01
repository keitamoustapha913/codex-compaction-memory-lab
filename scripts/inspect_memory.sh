#!/usr/bin/env bash
set -euo pipefail

find .codex-state -maxdepth 3 -type f -print | sort

echo
if [[ -f .codex-state/LIVE_MEMORY.md ]]; then
  echo "===== LIVE_MEMORY.md ====="
  cat .codex-state/LIVE_MEMORY.md
fi

echo
if [[ -f .codex-state/compaction-events.jsonl ]]; then
  echo "===== compaction-events.jsonl ====="
  cat .codex-state/compaction-events.jsonl
fi

echo
if [[ -f .codex-state/prompt-events.jsonl ]]; then
  echo "===== prompt-events.jsonl ====="
  cat .codex-state/prompt-events.jsonl
fi
