# Part 01 Audit

## Observed bug

`safe_divide()` returns `0.0` when called with a zero denominator instead of raising `ZeroDivisionError`.

## Affected file

`src/codex_memory_lab/calculator.py`

## Expected behavior from tests

`tests/test_calculator.py` defines two expectations:

- `safe_divide(10, 2)` returns `5`
- `safe_divide(10, 0)` raises `ZeroDivisionError`

## Exact validation command needed in Part 02

`uv run --python 3.10 pytest`
