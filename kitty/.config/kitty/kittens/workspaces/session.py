"""
Session helper kitten for kitty.
Automatically saves the current session and performs the action given by args.
"""

from typing import Literal, cast
from kitty.window import Window
from kittens.tui.handler import result_handler
from kitty.boss import Boss

import re

from shared import is_ssh_session, save_session


WindowType = Literal["window", "tab"]
MoveDirection = Literal["forward", "backward"]


def parse_ssh_base(target: str) -> str:
    """
    Strip trailing number to get the base host name.
    """

    match = re.match(r"^(.+?)(\d+)$", target)
    if match:
        return match.group(1)

    return target


def find_next_session(boss: Boss, window: Window, base: str) -> str:
    """
    Find the first available session name within the same OS window.
    """

    used: set[int] = set()

    os_window_id = window.os_window_id
    tm = boss.os_window_map.get(os_window_id)
    if not tm:
        return f"{base}1"

    for tab in tm.tabs:
        for w in tab.windows:
            fg = w.child.foreground_processes  # ty:ignore[unresolved-attribute]
            if not fg:
                continue

            cmdline = fg[0]["cmdline"]
            if not cmdline[0].endswith("ssh") or len(cmdline) < 2:
                continue

            target = cmdline[1]
            if target == base:
                used.add(1)
                continue

            match = re.match(r"^(.+?)(\d+)$", target)
            if match and match.group(1) == base:
                used.add(int(match.group(2)))

    n = 2
    while n in used:
        n += 1

    return f"{base}{n}"


def handle_window_action(boss: Boss, window: Window | None, type: WindowType):
    def open_new_plain():
        return boss.call_remote_control(
            window, ("launch", "--type", type, "--cwd", "current")
        )

    if not window:
        open_new_plain()
        return

    is_ssh, cmdline = is_ssh_session(window)
    if is_ssh and len(cmdline) > 1:
        base = parse_ssh_base(cmdline[1])
        target = find_next_session(boss, window, base)
        boss.call_remote_control(
            window,
            ("launch", "--type", type, "--cwd", "current", cmdline[0], target),
        )
        save_session(boss, window)

        return

    open_new_plain()


def handle_move_action(
    boss: Boss, window: Window | None, direction: MoveDirection
):

    match direction:
        case "forward":
            boss.move_tab_forward()
        case "backward":
            boss.move_tab_backward()

    is_ssh, _ = is_ssh_session(window)
    if is_ssh:
        save_session(boss, window)


def main(_args: list[str]):
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str], _answer: str, target_window_id: int, boss: Boss
) -> None:
    if len(args) < 2 or not args[1]:
        return

    window = boss.window_id_map.get(target_window_id)

    match args[1]:
        case "new_window":
            handle_window_action(boss, window, "window")
        case "new_tab":
            handle_window_action(boss, window, "tab")
        case "move_tab":
            if len(args) < 3:
                return

            if args[2] not in ("forward", "backward"):
                return

            handle_move_action(boss, window, cast(MoveDirection, args[2]))
