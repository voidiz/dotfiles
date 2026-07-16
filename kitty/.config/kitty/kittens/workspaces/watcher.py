import sys
from pathlib import Path
from typing import Any

# Watchers don't seem to get the parent directory added to their sys.path, so
# we have to do it ourselves
sys.path.insert(0, str(Path(__file__).parent))

from kitty.boss import Boss
from kitty.window import Window

from shared import is_ssh_session, save_session


def find_sibling_window(boss: Boss, window: Window) -> Window | None:
    """
    Find another window in the same OS window and session that isn't the one
    being closed.
    """

    tm = boss.os_window_map.get(window.os_window_id)
    if not tm:
        return None

    session_name = window.created_in_session_name
    for tab in tm.tabs:
        for w in tab.windows:
            if w.id != window.id and w.created_in_session_name == session_name:  # ty:ignore[unresolved-attribute]
                return w  # ty:ignore[invalid-return-type]

    return None


# Save session when a window is closed.
def on_close(boss: Boss, window: Window, _data: dict[str, Any]) -> None:
    # Don't do anything when the OS window is closed
    if window.os_window_id not in boss.os_window_map:
        return

    # Window must be an ssh window inside a kitty session
    is_ssh, _ = is_ssh_session(window)
    if not is_ssh:
        return

    sibling = find_sibling_window(boss, window)
    if sibling:
        save_session(boss, sibling)
        return
    else:
        # Last window in the session — delete the session file
        session_name = window.created_in_session_name
        if session_name:
            from picker import delete_session_file

            delete_session_file(session_name)
