from pathlib import Path
from kitty.window import Window
from kitty.boss import Boss
from kitty.fast_data_types import add_timer  # ty:ignore[unresolved-import]
from kitty.session import seen_session_paths

import os

SESSIONS_DIR = (
    Path(os.getenv("XDG_DATA_HOME", str(Path.home() / ".local" / "share")))
    / "kitty"
    / "sessions"
)


def is_ssh_session(window: Window | None) -> tuple[bool, list[str]]:
    """
    Returns true if the window is an ssh session and belongs to a kitty
    session.

    Second return value is the cmdline. Falls back to child.argv when
    foreground_processes is empty (e.g. in on_close after process exit).
    """

    # created_in_session_name is empty if the window doesn't belong to a
    # session
    if not window or not window.created_in_session_name:
        return False, []

    fg = window.child.foreground_processes  # ty:ignore[unresolved-attribute]
    if fg:
        cmdline: list[str] = fg[0]["cmdline"]
    else:
        cmdline = list(window.child.argv)  # ty:ignore[unresolved-attribute]

    if not cmdline:
        return False, []

    return cmdline[0].endswith("ssh"), cmdline


def save_session(boss: Boss, window: Window | None):
    # Resolve the session path now, before the timer fires
    if not window or not window.created_in_session_name:
        return

    path = seen_session_paths.get(window.created_in_session_name)
    if not path:
        return

    def _do_save(*_):
        boss.call_remote_control(
            window,
            (
                "action",
                "--no-response",
                "save_as_session",
                "--use-foreground-process",
                "--save-only",
                "--match=session:.",
                path,
            ),
        )

    # Defer to next event loop tick so any dying window are fully removed
    #
    # Signature:
    # - callback taking a timer ID
    # - delay between calls
    # - whether it should be called repeatedly
    add_timer(_do_save, 0.0, False)


def delete_session_file(name: str) -> bool:
    """
    Delete a session file. Returns True if exists and deleted.
    """

    filepath = SESSIONS_DIR / f"{name}.kitty-session"
    if filepath.exists():
        filepath.unlink()
        return True

    return False
