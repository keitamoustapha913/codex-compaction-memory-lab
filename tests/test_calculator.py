import pytest

from codex_memory_lab import safe_divide


def test_safe_divide_normal_case() -> None:
    assert safe_divide(10, 2) == 5


def test_safe_divide_zero_denominator_raises() -> None:
    with pytest.raises(ZeroDivisionError):
        safe_divide(10, 0)
