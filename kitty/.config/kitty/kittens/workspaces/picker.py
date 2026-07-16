"""
Interactive workspace picker kitten for kitty.

Features:
- Type to substring-filter existing sessions
- Enter to switch to the best match, or create a new session if no match
- Ctrl+D to delete the highlighted session
- Escape/Ctrl+C to cancel
"""

from pathlib import Path
from typing import cast

import os

from kitty.boss import Boss
from kitty.typing_compat import KeyEventType, ScreenSize as ScreenSizeType
from kitty.key_encoding import EventType, KeyEvent
from kitty.utils import ScreenSize

from kittens.tui.handler import Handler, result_handler
from kittens.tui.line_edit import LineEdit
from kittens.tui.loop import Loop
from kittens.tui.operations import (
    clear_screen,
    set_cursor_visible,
    styled,
)

from shared import delete_session_file, SESSIONS_DIR


def base_session_content(name: str) -> str:
    return f"""\
new_tab
layout tall
launch ssh d.{name}1
"""


def list_sessions() -> list[str]:
    """
    Return sorted list of session names from the sessions directory.
    """

    os.makedirs(SESSIONS_DIR, exist_ok=True)

    sessions = []
    for p in sorted(SESSIONS_DIR.iterdir()):
        if p.name.endswith(".kitty-session"):
            sessions.append(p.stem)

    return sessions


def create_session_file(name: str) -> Path:
    """
    Create a minimal session file. Returns the path.
    """

    filepath = SESSIONS_DIR / f"{name}.kitty-session"
    filepath.write_text(base_session_content(name))
    return filepath


def substring_match(query: str, target: str) -> int | None:
    """
    Simple substring match score. Returns match position or None if no match.
    Lower is better.
    """

    if not query:
        return 0

    lower_target = target.lower()
    lower_query = query.lower()
    pos = lower_target.find(lower_query)
    if pos >= 0:
        return pos

    return None


def filter_and_rank(query: str, sessions: list[str]) -> list[str]:
    """
    Filter sessions by query and return ranked by match quality.
    """

    if not query:
        return sessions[:]

    scored: list[tuple[int, str]] = []
    for s in sessions:
        score = substring_match(query, s)
        if score is not None:
            scored.append((score, s))

    scored.sort(key=lambda x: (x[0], x[1]))
    return [s for _, s in scored]


class WorkspacePicker(Handler):
    def __init__(self) -> None:
        super().__init__()
        self.line_edit = LineEdit()
        self.sessions: list[str] = []
        self.filtered: list[str] = []
        self.selected_idx = 0
        self.result = ""
        self.message = ""

    def initialize(self) -> None:
        self.sessions = list_sessions()
        self.filtered = self.sessions[:]
        self.draw()

    def on_resize(self, screen_size: ScreenSizeType) -> None:
        super().on_resize(screen_size)
        self.draw()

    def on_text(self, text: str, in_bracketed_paste: bool = False) -> None:
        self.line_edit.on_text(text, in_bracketed_paste)
        self._update_filter()
        self.draw()

    def on_key(self, key_event: KeyEventType) -> None:
        key_event = cast(KeyEvent, key_event)

        if key_event.type is EventType.RELEASE:
            return

        if key_event.matches("escape"):
            self.quit_loop(1)
            return

        if key_event.matches("enter"):
            self._accept()
            return

        if key_event.matches("ctrl+d"):
            self._delete_selected()
            return

        if (
            key_event.matches("up")
            or key_event.matches("ctrl+p")
            or key_event.matches("ctrl+k")
        ):
            self._move_selection(-1)
            self.draw()
            return

        if (
            key_event.matches("down")
            or key_event.matches("ctrl+n")
            or key_event.matches("ctrl+j")
        ):
            self._move_selection(1)
            self.draw()
            return

        if key_event.matches("ctrl+u"):
            self.line_edit.clear()
            self._update_filter()
            self.draw()
            return

        if self.line_edit.on_key(key_event):
            self._update_filter()
            self.draw()

    def on_interrupt(self) -> None:
        self.quit_loop(1)

    def on_eot(self) -> None:
        self._delete_selected()

    def _update_filter(self) -> None:
        query = self.line_edit.current_input
        self.filtered = filter_and_rank(query, self.sessions)
        self.selected_idx = 0

    def _move_selection(self, delta: int) -> None:
        if not self.filtered:
            return

        self.selected_idx = (self.selected_idx + delta) % len(self.filtered)

    def _accept(self) -> None:
        if self.filtered:
            name = self.filtered[self.selected_idx]
        else:
            name = self.line_edit.current_input.strip()
            if not name:
                return

        session_file = SESSIONS_DIR / f"{name}.kitty-session"
        if not session_file.exists():
            create_session_file(name)

        self.result = str(session_file)
        self.quit_loop(0)

    def _delete_selected(self) -> None:
        if not self.filtered:
            return

        name = self.filtered[self.selected_idx]
        if delete_session_file(name):
            self.sessions = list_sessions()
            self._update_filter()
            self.message = f"Deleted: {name}"
        self.draw()

    @Handler.atomic_update
    def draw(self) -> None:
        self.write(set_cursor_visible(False))
        self.write(clear_screen())
        self._draw_header()
        self._draw_session_list()
        self._draw_message()
        self._draw_input()
        self._draw_footer()

    def _draw_header(self) -> None:
        self.print(styled(" Workspaces ", bold=True, fg="black", bg="white"))
        self.print("")

    def _draw_session_list(self) -> None:
        query = self.line_edit.current_input
        screen_size = cast(ScreenSize, self.screen_size)
        max_visible = max(1, screen_size.rows - 7)

        if self.filtered:
            start = max(0, self.selected_idx - max_visible + 1)
            end = start + max_visible
            visible = self.filtered[start:end]

            for i, name in enumerate(visible):
                actual_idx = start + i
                is_selected = actual_idx == self.selected_idx

                if is_selected:
                    display = self._highlight_match(name, query, selected=True)
                    self.print(styled(" > ", fg="green", bold=True) + display)
                else:
                    display = self._highlight_match(
                        name, query, selected=False
                    )
                    self.print("   " + display)

            if len(self.filtered) > max_visible:
                self.print(
                    styled(f"   ({len(self.filtered)} total)", dim=True)
                )
        else:
            if query:
                self.print(
                    styled(
                        f'   No match — Enter to create "{query}"', fg="yellow"
                    )
                )
            else:
                self.print(styled("   No sessions found", dim=True))

    def _draw_message(self) -> None:
        self.print("")
        if self.message:
            self.print(styled(f"  {self.message}", fg="yellow"))
            self.message = ""
        else:
            self.print("")

    def _draw_input(self) -> None:
        screen_size = cast(ScreenSize, self.screen_size)
        self.write("  > ")
        self.line_edit.write(self.write, screen_cols=screen_size.cols - 4)

    def _draw_footer(self) -> None:
        self.print("")
        self.print(
            styled("  enter", fg="cyan")
            + " select  "
            + styled("ctrl+d", fg="cyan")
            + " delete  "
            + styled("esc", fg="cyan")
            + " cancel"
        )

    def _highlight_match(
        self, name: str, query: str, selected: bool = False
    ) -> str:
        if not query:
            if selected:
                return styled(name, fg="green", bold=True)

            return name

        lower_name = name.lower()
        lower_query = query.lower()
        pos = lower_name.find(lower_query)
        if pos < 0:
            if selected:
                return styled(name, fg="green", bold=True)

            return name

        before = name[:pos]
        match = name[pos : pos + len(query)]
        after = name[pos + len(query) :]

        if selected:
            return (
                styled(before, fg="green", bold=True)
                + styled(match, fg="yellow", bold=True)
                + styled(after, fg="green", bold=True)
            )

        return before + styled(match, fg="yellow", bold=True) + after


def main(_args: list[str]) -> str:
    loop = Loop()
    handler = WorkspacePicker()
    loop.loop(handler)
    if handler.result:
        return handler.result
    raise SystemExit(1)


@result_handler()
def handle_result(
    _args: list[str], answer: str, _target_window_id: int, boss: Boss
) -> None:
    if not answer:
        return

    boss.goto_session(answer)
