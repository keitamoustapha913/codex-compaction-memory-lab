#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mkdir -p .codex-state/transcript-snapshots

# Reset only generated hook-test outputs, not LIVE_MEMORY.md.
rm -f .codex-state/compaction-events.jsonl
rm -f .codex-state/prompt-events.jsonl
rm -f .codex-state/session-start-output.json
rm -f .codex-state/fake-transcript.jsonl
rm -f .codex-state/transcript-snapshots/* || true

cat > .codex-state/fake-transcript.jsonl <<'EOF'
{"role":"user","content":"fake user prompt before compaction"}
{"role":"assistant","content":"fake assistant work before compaction"}
EOF

SESSION_ID="local-session-001"
TURN_ID="local-turn-001"
MODEL="local-test-model"
TRANSCRIPT="$ROOT/.codex-state/fake-transcript.jsonl"

python3 .codex/hooks/session_start_memory_loader.py <<EOF > /tmp/session-start.out
{
  "session_id": "$SESSION_ID",
  "transcript_path": "$TRANSCRIPT",
  "cwd": "$ROOT",
  "hook_event_name": "SessionStart",
  "model": "$MODEL",
  "source": "startup",
  "permission_mode": "dontAsk"
}
EOF
python3 -m json.tool /tmp/session-start.out >/dev/null

python3 .codex/hooks/user_prompt_submit_memory_reminder.py <<EOF > /tmp/user-prompt-submit.out
{
  "session_id": "$SESSION_ID",
  "turn_id": "$TURN_ID",
  "transcript_path": "$TRANSCRIPT",
  "cwd": "$ROOT",
  "hook_event_name": "UserPromptSubmit",
  "model": "$MODEL",
  "permission_mode": "dontAsk",
  "prompt": "Simulated prompt: keep durable memory current."
}
EOF
python3 -m json.tool /tmp/user-prompt-submit.out >/dev/null

python3 .codex/hooks/pre_compact_memory_snapshot.py <<EOF > /tmp/precompact.out
{
  "session_id": "$SESSION_ID",
  "turn_id": "$TURN_ID",
  "transcript_path": "$TRANSCRIPT",
  "cwd": "$ROOT",
  "hook_event_name": "PreCompact",
  "model": "$MODEL",
  "trigger": "auto"
}
EOF
python3 -m json.tool /tmp/precompact.out >/dev/null

python3 .codex/hooks/post_compact_marker.py <<EOF > /tmp/postcompact.out
{
  "session_id": "$SESSION_ID",
  "turn_id": "$TURN_ID",
  "transcript_path": "$TRANSCRIPT",
  "cwd": "$ROOT",
  "hook_event_name": "PostCompact",
  "model": "$MODEL",
  "trigger": "auto"
}
EOF
python3 -m json.tool /tmp/postcompact.out >/dev/null

echo "=== .codex-state files ==="
find .codex-state -maxdepth 3 -type f -print | sort

if ! grep -q '"event": "PreCompact"' .codex-state/compaction-events.jsonl; then
  echo "Missing PreCompact marker" >&2
  echo "precompact stdout:" >&2
  cat /tmp/precompact.out >&2 || true
  exit 1
fi

if ! grep -q '"event": "PostCompact"' .codex-state/compaction-events.jsonl; then
  echo "Missing PostCompact marker" >&2
  echo "postcompact stdout:" >&2
  cat /tmp/postcompact.out >&2 || true
  exit 1
fi

if ! grep -q 'Simulated prompt' .codex-state/prompt-events.jsonl; then
  echo "Missing prompt marker" >&2
  echo "user prompt stdout:" >&2
  cat /tmp/user-prompt-submit.out >&2 || true
  exit 1
fi

if ! find .codex-state/transcript-snapshots -type f -name '*precompact.jsonl' | grep -q .; then
  echo "Missing precompact transcript snapshot" >&2
  exit 1
fi

if ! find .codex-state/transcript-snapshots -type f -name '*postcompact.jsonl' | grep -q .; then
  echo "Missing postcompact transcript snapshot" >&2
  exit 1
fi

echo "LOCAL_HOOK_SIMULATION: PASS"
