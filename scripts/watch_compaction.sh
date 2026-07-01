#!/usr/bin/env bash
set -euo pipefail

FILE=".codex-state/compaction-events.jsonl"

echo "Watching for real compaction events in $FILE"
echo "Real proof requires non-empty records containing PreCompact/PostCompact."
echo

while true; do
  if [[ -s "$FILE" ]]; then
    clear
    echo "=== REAL COMPACTION EVENTS DETECTED ==="
    cat "$FILE"
  else
    printf '\r[%s] no PreCompact/PostCompact records yet' "$(date +%H:%M:%S)"
  fi
  sleep 1
done
