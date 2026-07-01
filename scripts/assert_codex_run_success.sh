#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <events.jsonl> <final.md>" >&2
  exit 2
fi

EVENTS="$1"
FINAL="$2"

if [[ ! -s "$EVENTS" ]]; then
  echo "CODEX FAILED: missing or empty events file: $EVENTS" >&2
  exit 1
fi

if [[ ! -s "$FINAL" ]]; then
  echo "CODEX FAILED: missing or empty final message file: $FINAL" >&2
  exit 1
fi

if ! grep -q '"type":"turn.completed"' "$EVENTS"; then
  echo "CODEX FAILED: no turn.completed in $EVENTS" >&2
  tail -n 80 "$EVENTS" >&2 || true
  exit 1
fi

if grep -q '"type":"turn.failed"\|"type":"error"' "$EVENTS"; then
  echo "CODEX FAILED: turn.failed or error found in $EVENTS" >&2
  grep -n '"type":"turn.failed"\|"type":"error"' "$EVENTS" >&2 || true
  exit 1
fi

if ! grep -q 'FINAL_STATUS: PASS' "$FINAL"; then
  echo "CODEX FINISHED BUT DID NOT PROVE SUCCESS: $FINAL" >&2
  cat "$FINAL" >&2
  exit 1
fi

echo "CODEX_RUN_GATE: PASS"
