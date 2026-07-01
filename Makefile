.PHONY: simulate inspect sequence test

simulate:
	./scripts/simulate_hooks.sh

inspect:
	./scripts/inspect_memory.sh

sequence:
	./scripts/run_codex_sequence.sh

test:
	python3 -m pytest
