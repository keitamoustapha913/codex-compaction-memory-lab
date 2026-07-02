# Compaction Evidence Policy

## Purpose

This lab distinguishes between:

```text
hooks configured
hooks locally simulated
hooks observed in real Codex runtime
real compaction observed
```

These are different evidence levels.

## Evidence Levels

### Level 1 — Hook Scripts Exist

The repository contains hook scripts and `.codex/hooks.json`.

This alone does not prove that Codex ran them.

### Level 2 — Local Simulation Passed

Command:

```bash
./scripts/simulate_hooks.sh
```

Expected:

```text
LOCAL_HOOK_SIMULATION: PASS
```

This proves the hook scripts work when invoked with representative JSON input.

### Level 3 — Real Non-Interactive Hooks Ran

Evidence files:

```text
.codex-state/prompt-events.jsonl
.codex-state/session-start-output.json
```

This proves real `codex exec` invoked `UserPromptSubmit` and `SessionStart`.

### Level 4 — Real Compaction Observed

Required evidence:

```text
.codex-state/compaction-events.jsonl
```

The file must be non-empty and contain one or both of:

```text
PreCompact
PostCompact
```

Valid check:

```bash
[[ -s .codex-state/compaction-events.jsonl ]] \
  && grep -Eq 'PreCompact|PostCompact' .codex-state/compaction-events.jsonl
```

## Non-Evidence

The following do not prove compaction:

```text
- an empty compaction-events.jsonl file
- an empty transcript-snapshots directory
- a large input token count
- a successful stress prompt
- cached input tokens
- the model reading a large file
```

## Current Result

Real `codex exec` runs have successfully used large token budgets, but no real PreCompact/PostCompact event has been observed yet.

Current classification:

```text
NO_REAL_COMPACTION_OBSERVED
```

## Correct Reporting

If no non-empty compaction event file exists:

```text
PreCompact/PostCompact did not fire during this run.
```

Do not report:

```text
compaction happened
```

unless the event file contains `PreCompact` or `PostCompact`.
