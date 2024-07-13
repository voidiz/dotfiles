from typing import List, Literal
from kittens.tui.handler import result_handler
from kitty.boss import Boss


def main(args: List[str]) -> str:
    pass


def window_exists(
    boss, window, neighbor: Literal["top"] | Literal["bottom"]
) -> bool:
    try:
        boss.call_remote_control(
            window, ("ls", f"--match=neighbor:{neighbor}")
        )
        return True
    except:
        # throws an error when a neighbor wasn't found
        return False


@result_handler(no_ui=True)
def handle_result(
    _args: List[str], _answer: str, target_window_id: int, boss: Boss
) -> None:
    window = boss.window_id_map.get(target_window_id)
    tab = boss.active_tab

    if window is None:
        return
    if tab is None:
        return

    if len(tab.windows) == 1:
        # make sure that we are in fat layout before launching new window
        # otherwise the new window might be launched in stack layout
        boss.call_remote_control(
            window, ("goto-layout", "--match=state:focused", "fat")
        )
        boss.call_remote_control(
            None,
            (
                "launch",
                "--type=window",
                "--cwd=current",
                "--title=current",
            ),
        )
    elif tab.current_layout.name == "stack":
        boss.call_remote_control(
            window, ("goto-layout", "--match=state:focused", "fat")
        )
        # go to bottom window if it exists
        if window_exists(boss, window, "bottom"):
            boss.call_remote_control(
                window,
                ("focus-window", "--match=neighbor:bottom", "--no-response"),
            )
    elif tab.current_layout.name == "fat":
        # go to top window if it exists
        if window_exists(boss, window, "top"):
            boss.call_remote_control(
                window,
                ("focus-window", "--match=neighbor:top", "--no-response"),
            )
        boss.call_remote_control(
            window, ("goto-layout", "--match=state:focused", "stack")
        )
