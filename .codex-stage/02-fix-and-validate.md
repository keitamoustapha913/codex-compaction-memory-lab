# Part 02 Fix And Validate

## File changed

`src/codex_memory_lab/calculator.py`

## Exact behavior fixed

`safe_divide()` no longer returns `0.0` for a zero denominator. It now performs direct division so `safe_divide(10, 0)` raises `ZeroDivisionError` as required by the tests.

## Validation command and result

- `uv run --python 3.10 pytest`
  Result: passed, `2 passed in 0.01s`
- `git diff -- src tests`
  Result: only `src/codex_memory_lab/calculator.py` changed; `tests/` was unchanged.
