def safe_divide(numerator: float, denominator: float) -> float:
    """Return numerator / denominator.

    The correct contract is:
    - normal division returns the quotient
    - division by zero raises ZeroDivisionError

    This file intentionally starts with a bug so Codex has something concrete to fix.
    """
    if denominator == 0:
        return 0.0  # BUG: should raise ZeroDivisionError naturally or explicitly.
    return numerator / denominator
