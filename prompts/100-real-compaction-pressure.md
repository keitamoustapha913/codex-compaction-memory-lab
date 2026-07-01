You are running a real compaction pressure test.

Before doing anything:
1. Read AGENTS.md.
2. Read .codex-state/LIVE_MEMORY.md.
3. Read .codex-stage/large-context-payload.md completely.

Rules:
- Keep durable continuity in .codex-state/LIVE_MEMORY.md.
- Do not use .codex/memory as project memory.
- Update .codex-state/LIVE_MEMORY.md after each major checkpoint.
- Write .codex-stage/100-real-compaction-pressure.md.

Required work:
1. Process the large payload in 10 ranges:
   - 1-250
   - 251-500
   - 501-750
   - 751-1000
   - 1001-1250
   - 1251-1500
   - 1501-1750
   - 1751-2000
   - 2001-2250
   - 2251-2500
2. For each range, write a compact checkpoint to LIVE_MEMORY.md.
3. In the stage artifact, record:
   - every processed range
   - whether .codex-state/compaction-events.jsonl exists
   - whether .codex-state/transcript-snapshots exists
   - final validation evidence

Required validation:
- Run: test -f .codex-stage/100-real-compaction-pressure.md
- Run: grep -q 'RANGE_2001_2250_COMPLETE' .codex-state/LIVE_MEMORY.md
- Run: grep -q 'RANGE_2251_2500_COMPLETE' .codex-state/LIVE_MEMORY.md

Final response must end with exactly one of:
FINAL_STATUS: PASS
FINAL_STATUS: FAIL

Print FINAL_STATUS: PASS only if all required ranges were processed, LIVE_MEMORY.md contains the final markers, and the artifact exists.
