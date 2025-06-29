import os


def terminal_from_env() -> str:
    terminal = os.environ.get("TERMINAL", "xterm")
    return terminal


def terminal_run_command(
    terminal: str,
    command: list[str],
    options: list[str] | None = None,
) -> str:
    options = options or []

    if terminal in ("kitty", "foot"):
        cl = [terminal] + options + command

    elif terminal in ("tilda",):
        cl = [terminal] + options + ["-c"] + command

    else:
        cl = [terminal] + options + ["-e"] + command

    return " ".join(cl)
