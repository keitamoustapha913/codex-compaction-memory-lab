# Codex Compaction Memory Lab

A small Git repository for testing Codex CLI non-interactive sequencing, compaction hooks, and durable memory handoff.

The repo demonstrates this pattern:

```text
codex exec part 1
  -> hooks log prompt/session/compaction events
  -> Codex updates .codex-state/LIVE_MEMORY.md
  -> wrapper checks turn.completed + FINAL_STATUS: PASS
codex exec part 2
  -> re-reads durable memory and previous stage artifacts
  -> fixes a deliberately broken test target
  -> wrapper gates the next step
codex exec part 3
  -> reconciles memory, git diff, tests, and final state
```

## What this repo contains

```text
.codex/hooks.json                         # Project-local Codex hooks
.codex/hooks/session_start_memory_loader.py
.codex/hooks/user_prompt_submit_memory_reminder.py
.codex/hooks/pre_compact_memory_snapshot.py
.codex/hooks/post_compact_marker.py
.codex-state/LIVE_MEMORY.md              # Durable memory Codex must maintain
prompts/01-audit-readonly.md              # Stage 1 prompt
prompts/02-fix-and-validate.md            # Stage 2 prompt
prompts/03-final-reconcile.md             # Stage 3 prompt
scripts/simulate_hooks.sh                 # Local hook test; no Codex needed
scripts/run_codex_sequence.sh             # Real non-interactive Codex sequence
scripts/assert_codex_run_success.sh       # JSONL/final-message gate
src/codex_memory_lab/calculator.py        # Deliberately buggy code
pytest.ini
pyproject.toml
tests/test_calculator.py
```

## 1. Initialize the test repo

```bash
cd codex-compaction-memory-lab
git init
git add .
git commit -m "init codex compaction memory lab"
```

Codex requires `codex exec` to run inside a Git repository unless you explicitly skip that safety check.

## 2. Run the local hook simulation first

This does **not** require Codex CLI. It sends fake JSON hook events to the hook scripts so you can verify that memory files and compaction logs are written.

```bash
./scripts/simulate_hooks.sh
```

Expected output ends with:

```text
LOCAL_HOOK_SIMULATION: PASS
```

Inspect the generated files:

```bash
find .codex-state -maxdepth 3 -type f -print
cat .codex-state/compaction-events.jsonl
cat .codex-state/session-start-output.json
```

## 3. Run the real Codex non-interactive sequence

First make sure Codex CLI is installed and authenticated:

```bash
codex --version
```

Then run:

```bash
./scripts/run_codex_sequence.sh
```

If your project-local hooks are not yet trusted, either open interactive Codex and review `/hooks`, or for this isolated toy lab only run:

```bash
CODEX_BYPASS_HOOK_TRUST=1 ./scripts/run_codex_sequence.sh
```

The wrapper stops immediately if any part does not satisfy all gates:

```text
- codex exec exits successfully
- event stream contains turn.completed
- event stream does not contain turn.failed or error
- final message contains FINAL_STATUS: PASS
```

## 4. Force a memory-heavy run

The easiest way to stress context is to ask Codex to produce and preserve a long chain of facts in `LIVE_MEMORY.md`, then continue through multiple phases.

```bash
CODEX_BYPASS_HOOK_TRUST=1 codex exec \
  --cd "$PWD" \
  --json \
  --output-last-message .codex-runs/manual-final.md \
  --sandbox workspace-write \
  --ask-for-approval never \
  --dangerously-bypass-hook-trust \
  - < prompts/99-memory-stress.md \
  > .codex-runs/manual-events.jsonl
```

Compaction may not happen in a short toy run. This repo still proves that:

1. Codex can run project hooks.
2. `SessionStart` can re-inject durable memory.
3. `PreCompact` and `PostCompact` scripts can snapshot/mark compaction when Codex triggers them.
4. The sequence wrapper can use filesystem artifacts instead of relying on fragile active chat memory.

## Safety notes

`--dangerously-bypass-hook-trust` only bypasses hook trust review, not the normal command sandbox. Use it only when you already trust this repo's hook scripts. Do **not** confuse it with `--dangerously-bypass-approvals-and-sandbox`, which disables approval prompts and sandboxing and should only be used inside a hardened throwaway runner.
