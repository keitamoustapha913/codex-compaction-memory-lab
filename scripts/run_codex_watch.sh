#!/usr/bin/env bash
set -euo pipefail

PROMPT_FILE="${1:?usage: scripts/run_codex_watch.sh prompts/file.md}"
ROOT="${2:-$(pwd)}"
ROOT="$(cd "$ROOT" && pwd)"
cd "$ROOT"

mkdir -p .codex-runs .codex-state
RUN_ID="$(date +%Y%m%d-%H%M%S)"
EVENTS=".codex-runs/$RUN_ID-events.jsonl"
STDERR_LOG=".codex-runs/$RUN_ID-stderr.log"
FINAL=".codex-runs/$RUN_ID-final.md"

CODEX_MODEL="${CODEX_MODEL:-gpt-5.4-mini}"
CODEX_REASONING="${CODEX_REASONING:-medium}"
CODEX_REASONING_SUMMARY="${CODEX_REASONING_SUMMARY:-auto}"
CODEX_VERBOSITY="${CODEX_VERBOSITY:-medium}"

echo "RUN_ID=$RUN_ID"
echo "MODEL=$CODEX_MODEL"
echo "REASONING=$CODEX_REASONING"
echo "REASONING_SUMMARY=$CODEX_REASONING_SUMMARY"
echo "VERBOSITY=$CODEX_VERBOSITY"
echo "EVENTS=$EVENTS"
echo "STDERR=$STDERR_LOG"
echo "FINAL=$FINAL"
echo

cat > ".codex-runs/$RUN_ID-run-config.json" <<EOF
{
  "run_id": "$RUN_ID",
  "model": "$CODEX_MODEL",
  "reasoning": "$CODEX_REASONING",
  "reasoning_summary": "$CODEX_REASONING_SUMMARY",
  "verbosity": "$CODEX_VERBOSITY",
  "prompt_file": "$PROMPT_FILE"
}
EOF

codex exec \
  --cd "$ROOT" \
  --model "$CODEX_MODEL" \
  --json \
  --sandbox workspace-write \
  -c approval_policy=never \
  -c features.hooks=true \
  -c model_reasoning_effort="$CODEX_REASONING" \
  -c model_reasoning_summary="$CODEX_REASONING_SUMMARY" \
  -c model_verbosity="$CODEX_VERBOSITY" \
  --dangerously-bypass-hook-trust \
  --output-last-message "$FINAL" \
  - < "$PROMPT_FILE" \
  2> >(tee "$STDERR_LOG" >&2) \
  | tee "$EVENTS" \
  | scripts/watch_codex_jsonl.py

echo
echo "=== FINAL MESSAGE ==="
cat "$FINAL"

echo
echo "=== COMPACTION EVENTS ==="
if [[ -s .codex-state/compaction-events.jsonl ]]; then
  cat .codex-state/compaction-events.jsonl
else
  echo "<none: PreCompact/PostCompact did not fire>"
fi

echo
echo "=== SNAPSHOTS ==="
if [[ -d .codex-state/transcript-snapshots ]] && find .codex-state/transcript-snapshots -type f | grep -q .; then
  find .codex-state/transcript-snapshots -type f -print | sort
else
  echo "<none>"
fi

echo
echo "=== HOOK MODELS ==="
if [[ -s .codex-state/prompt-events.jsonl ]]; then
  python3 - <<'PY'
import json
from pathlib import Path

p = Path(".codex-state/prompt-events.jsonl")
for line in p.read_text().splitlines()[-10:]:
    if not line.strip():
        continue
    obj = json.loads(line)
    print(f"{obj.get('time_utc')} {obj.get('event')} model={obj.get('model')}")
PY
else
  echo "<none>"
fi
