"""
session.py

A kitten for saving and restoring kitty state.

Usage:
Place this file in the kittens directory in the same directory
as kitty.conf. Then, in your kitty conf:

map alt+w               kitten kittens/session.py --restore
map alt+q               kitten kittens/session.py --save
"""

import os
from typing import List
from pathlib import Path

try:
    # For pyright
    from .kitty.kitty.boss import Boss
    from .kitty.kitty.session import create_sessions
    from .kitty.kitty.fast_data_types import get_options
except:
    # Actual import when running as a kitten
    from kitty.boss import Boss
    from kitty.session import create_sessions
    from kitty.fast_data_types import get_options

SESSIONS_DIR = Path(Path.home(), ".config", "kitty", ".sessions")


def main(args: List[str]) -> str:
    print("Saved Sessions:")
    sorted_sessions = sorted(
        SESSIONS_DIR.iterdir(), key=os.path.getmtime, reverse=True
    )
    for n, session_path in enumerate(sorted_sessions):
        print(f"{n + 1}. {session_path.name}")

    print()

    if args[1] == "--save":
        return input("Enter session name (leave blank to quit): ")

    if args[1] == "--restore":
        while True:
            try:
                num = input(
                    "Choose a session number to restore (leave blank to quit): "
                )
                if not num:
                    return ""

                return sorted_sessions[int(num) - 1].name
            except:
                print("Invalid session number")

    return ""


def handle_result(
    args: List[str], input: str, target_window_id: int, boss: Boss
) -> None:
    if not input:
        return

    if args[1] == "--save":
        save_session(input, target_window_id, boss)
    elif args[1] == "--restore":
        restore_session(input, target_window_id, boss)


def save_session(name: str, target_window_id: int, boss: Boss) -> None:
    """
    Save the session to file and close the window.
    """

    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    os_window = boss.os_window_map.get(window.os_window_id)
    if os_window is None:
        return

    lines: list[str] = []
    for tab in os_window.list_tabs():
        tab_title = tab.get("title")
        tab_layout = tab.get("layout")

        lines.append(f"new_tab {tab_title}")
        lines.append(f"layout {tab_layout}")

        for tab_window in tab.get("windows"):
            tab_window_title = tab_window.get("title")
            lines.append(f"title {tab_window_title}")

            tab_window_env = tab_window.get("env")
            env_flags = " ".join(
                f"--env {k}={v}" for k, v in tab_window_env.items()
            )

            foreground_processes = tab_window.get("foreground_processes")
            for pn, process in enumerate(foreground_processes):
                cmdline = process.get("cmdline")
                cwd = process.get("cwd")
                if not cmdline:
                    continue

                # Unfortunately we cannot launch child processes,
                # so we simulate it by just overlaying all processes over
                # each other
                # if len(foreground_processes) == 1:
                #     overlay_flag = ""
                # elif pn == len(foreground_processes) - 1:
                #     overlay_flag = "--type=overlay-main"
                # else:
                #     overlay_flag = "--type=overlay"
                overlay_flag = ""

                cmd = " ".join(cmdline)
                cwd_flag = f"--cwd={cwd}" if cwd else ""

                lines.append(
                    f"launch {cwd_flag} {env_flags} {overlay_flag} {cmd}"
                )

            if tab_window.get("is_focused"):
                lines.append("focus")

    SESSIONS_DIR.mkdir(parents=True, exist_ok=True)
    sorted_sessions = sorted(
        SESSIONS_DIR.iterdir(), key=os.path.getmtime, reverse=True
    )

    # Only store the latest 5 sessions
    if len(sorted_sessions) > 5:
        # Delete the 5th to make room for a new one
        for session_path in sorted_sessions[4:]:
            session_path.unlink()

    session_path = Path(SESSIONS_DIR, name)
    with open(session_path, "w", encoding="utf-8") as f:
        f.writelines([f"{line}\n" for line in lines])

    boss.close_os_window()


def restore_session(name: str, target_window_id: int, boss: Boss) -> None:
    """
    Restore a session from file.
    """

    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    session_path = Path(SESSIONS_DIR, name)
    startup_session = next(
        create_sessions(
            get_options(), default_session=session_path.resolve().as_posix()
        )
    )

    # Create a new window with the session
    boss.add_os_window(startup_session)

    # Close this window
    boss.mark_os_window_for_close(window.os_window_id)
