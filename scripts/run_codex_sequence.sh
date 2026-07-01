#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$(pwd)}"
ROOT="$(cd "$ROOT" && pwd)"
cd "$ROOT"

if ! command -v uv >/dev/null 2>&1; then
  echo "ERROR: uv is required but not found on PATH." >&2
  exit 127
fi

# Force the lab validation environment to Python 3.10.
uv python pin 3.10 >/dev/null
uv sync --dev

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found. Install/authenticate Codex before running this script." >&2
  exit 127
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "This must run inside a git repository. Run: git init && git add . && git commit -m init" >&2
  exit 2
fi

RUN_ID="$(date +%Y%m%d-%H%M%S)"
OUT_DIR=".codex-runs/$RUN_ID"
mkdir -p "$OUT_DIR" .codex-stage

CODEX_COMMON=(
  --cd "$ROOT"
  --json
  --sandbox workspace-write
  -c approval_policy=never
  -c features.hooks=true
)

if [[ "${CODEX_BYPASS_HOOK_TRUST:-0}" == "1" ]]; then
  CODEX_COMMON+=(--dangerously-bypass-hook-trust)
fi

run_part() {
  local part_id="$1"
  local prompt_file="$2"
  local events="$OUT_DIR/$part_id-events.jsonl"
  local final="$OUT_DIR/$part_id-final.md"

  echo "=== Running $part_id ==="

  codex exec \
    "${CODEX_COMMON[@]}" \
    --output-last-message "$final" \
    - < "$prompt_file" \
    > "$events"

  ./scripts/assert_codex_run_success.sh "$events" "$final"
  echo "=== Passed $part_id ==="
}

run_part "01-audit-readonly" "prompts/01-audit-readonly.md"
run_part "02-fix-and-validate" "prompts/02-fix-and-validate.md"
run_part "03-final-reconcile" "prompts/03-final-reconcile.md"

# Independent wrapper-side checks after Codex has finished.
uv run --python 3.10 pytest

grep -q 'PART_01_AUDIT_COMPLETE' .codex-state/LIVE_MEMORY.md
grep -q 'PART_02_FIX_VALIDATED' .codex-state/LIVE_MEMORY.md
grep -q 'PART_03_FINAL_RECONCILED' .codex-state/LIVE_MEMORY.md

echo "ALL_CODEX_SEQUENCE_PARTS: PASS"
echo "Run artifacts: $OUT_DIR"
