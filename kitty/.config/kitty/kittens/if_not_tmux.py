from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(_args: list[str]):
    pass


@result_handler(no_ui=True)
def handle_result(
    args: list[str], _answer: str, target_window_id: int, boss: Boss
) -> None:
    w = boss.window_id_map.get(target_window_id)
    if w is None:
        return

    if all((part != "tmux" for part in w.last_cmd_cmdline.split(" "))):
        # Only call the given action if not inside tmux
        boss.call_remote_control(w, ("action",) + tuple(args[1:-1]))
    else:
        # Send the text sequence otherwise
        # raw_stroke = args[-1].encode("utf-8").decode("unicode_escape")
        # w.write_to_child(raw_stroke)
        boss.call_remote_control(w, ("action", "send_key", args[-1]))
