# Keybindings for groups are defined in groups.py

from libqtile.config import Click, Drag, Key  # type: ignore
from libqtile.lazy import lazy  # type: ignore

from .window import float_to_front
from .settings.typedefs import Settings


GROUP_SWITCH = ["cmd", "alt"]

QTILE_CONTROL = ["cmd", "alt", "ctrl"]

SCREEN_SWITCH = ["cmd", "alt", "ctrl"]

VT_SWITCH = ["ctrl", "alt"]

WINDOW_SWITCH = ["cmd"]
WINDOW_MOVE = ["cmd", "shift"]
WINDOW_CONTROL = ["cmd", "ctrl"]
WINDOW_ALT_CONTROL = ["cmd", "ctrl", "alt"]

APP_LAUNCH = ["cmd", "alt"]


def user_menu(settings: Settings):
    # launch = [settings["key"][name] for name in (LAUNCH_APP)]
    return [
        # Key(
        #     modifiers,
        #     "F1",
        #     lazy.spawn("user-menu"),
        #     desc="Show the user menu",
        # ),
    ]


def system_menu(settings: Settings):
    launch = [settings["key"][name] for name in (APP_LAUNCH)]
    return [
        Key(
            launch,
            "F12",
            lazy.spawn("system-menu"),
            desc="Show the system menu",
        ),
    ]


def application(settings: Settings):
    launch = [settings["key"][name] for name in (APP_LAUNCH)]
    return [
        # Launcher
        Key(
            launch,
            "Return",
            lazy.spawn(settings["app"]["app_launcher"]),
            desc="Show the rofi app launcher (drun)",
        ),
        # Browser
        Key(
            launch,
            "w",
            lazy.spawn(settings["app"]["browser"]),
            desc="Start the browser",
        ),
        # Brain
        Key(
            launch,
            "b",
            lazy.spawn(settings["app"]["brain"]),
            desc="Start the Brain",
        ),
        # Code Editor
        Key(
            launch,
            "c",
            lazy.spawn(settings["app"]["code"]),
            desc="Start Coding",
        ),
        # Terminal
        Key(
            launch,
            "t",
            lazy.spawn(settings["app"]["terminal"]),
            desc="Start the terminal",
        ),
    ]


def layout(settings: Settings):
    cmd = settings["key"]["cmd"]
    return [
        Key(
            [cmd],
            "grave",
            lazy.next_layout(),
            desc="Switch to next layout",
        ),
    ]


def window(settings: Settings):
    switch = [settings["key"][name] for name in (WINDOW_SWITCH)]
    move = [settings["key"][name] for name in (WINDOW_MOVE)]
    control = [settings["key"][name] for name in (WINDOW_CONTROL)]
    alt_control = [settings["key"][name] for name in (WINDOW_ALT_CONTROL)]

    return [
        # region Switch
        Key(
            switch,
            "h",
            lazy.layout.up(),
            desc="Previous window",
        ),
        Key(
            switch,
            "l",
            lazy.layout.down(),
            desc="Next window",
        ),
        Key(
            switch,
            "Left",
            lazy.layout.up(),
            desc="Previous window",
        ),
        Key(
            switch,
            "Right",
            lazy.layout.down(),
            desc="Next window",
        ),
        # endregion
        # region Move
        Key(
            move,
            "Right",
            lazy.layout.shuffle_down(),
            desc="Move window down in stack",
        ),
        Key(
            move,
            "Left",
            lazy.layout.shuffle_up(),
            desc="Move window up in stack",
        ),
        Key(
            move,
            "l",
            lazy.layout.shuffle_down(),
            desc="Move window down in stack",
        ),
        Key(
            move,
            "h",
            lazy.layout.shuffle_up(),
            desc="Move window up in stack",
        ),
        # endregion
        # region Control
        Key(
            move,
            "f",
            float_to_front,
        ),
        Key(
            control,
            "c",
            lazy.window.kill(),
            desc="Close window",
        ),
        Key(
            control,
            "f",
            lazy.window.toggle_floating(),
            desc="Toggle floating window",
        ),
        Key(
            alt_control,
            "f",
            lazy.window.toggle_maximize(),
            desc="Toggle maximized window",
        ),
        # endregion
        # region Size
        Key(
            control,
            "Right",
            lazy.layout.grow_main(),
            desc="Increase Main Window Size",
        ),
        Key(
            control,
            "l",
            lazy.layout.grow_main(),
            desc="Increase Main Window Size",
        ),
        Key(
            control,
            "Left",
            lazy.layout.shrink_main(),
            desc="Decrease Main Window Size",
        ),
        Key(
            control,
            "h",
            lazy.layout.shrink_main(),
            desc="Decrease Main Window Size",
        ),
        Key(
            control,
            "Up",
            lazy.layout.grow(),
            desc="Increase Sub Window Size",
        ),
        Key(
            control,
            "j",
            lazy.layout.grow(),
            desc="Increase Sub Window Size",
        ),
        Key(
            control,
            "Down",
            lazy.layout.shrink(),
            desc="Decrease Sub Window Size",
        ),
        Key(
            control,
            "k",
            lazy.layout.shrink(),
            desc="Decrease Sub Window Size",
        ),
        # endregion
    ]


def group(settings: Settings):
    switch = [settings["key"][name] for name in (GROUP_SWITCH)]
    return [
        Key(
            switch,
            "Left",
            lazy.screen.prev_group(),
            desc="Switch to next group",
        ),
        Key(
            switch,
            "Right",
            lazy.screen.next_group(),
            desc="Switch to previous group",
        ),
    ]


def screen(settings: Settings):
    switch = [settings["key"][name] for name in (SCREEN_SWITCH)]
    return [
        Key(
            switch,
            "Right",
            lazy.next_scren(),
            desc="Switch to next screen",
        ),
        Key(
            switch,
            "Left",
            lazy.prev_scren(),
            desc="Switch to previous screen",
        ),
    ]


def clipboard(settings: Settings):
    launch = [settings["key"][name] for name in (APP_LAUNCH)]
    return [
        Key(
            launch,
            "Insert",
            lazy.spawn(
                "rofi-clip -c",
            ),
            desc="Copy an item from the clipboard history",
        ),
        Key(
            launch,
            "Delete",
            lazy.spawn(
                "rofi-clip -d",
            ),
            desc="Delete an item from the clipboard history",
        ),
    ]


def qtile(settings: Settings):
    control = [settings["key"][name] for name in (QTILE_CONTROL)]
    return [
        Key(
            control,
            "Home",
            lazy.reload_config(),
            desc="Reload QTile",
        ),
        Key(
            control,
            "End",
            lazy.spawn('loginctl terminate-user ""'),
            desc="Quit QTile",
        ),
    ]


def music(settings: Settings):
    fkey = [settings["key"][name] for name in ("cmd",)]
    launch = [settings["key"][name] for name in (APP_LAUNCH)]
    return [
        # Play / Pause
        Key(
            fkey,
            "F8",
            lazy.spawn("musicctl toggle"),
            desc="Toggle music play/pause",
        ),
        Key(
            fkey,
            "F7",
            lazy.spawn("musicctl previous"),
            desc="Switch to previous music track",
        ),
        Key(
            fkey,
            "F9",
            lazy.spawn("musicctl next"),
            desc="Switch to next music track",
        ),
        Key(
            launch + ["control"],
            "F8",
            lazy.spawn("pavucontrol"),
            desc="Pavucontrol",
        ),
        Key(
            launch,
            "F9",
            lazy.spawn("music-notify"),
            desc="Music notification",
        ),
    ]


def vt(settings: Settings):
    switch = [settings["key"][name] for name in (VT_SWITCH)]
    return [
        Key(
            switch,
            "F1",
            lazy.core.change_vt(1),
            desc="Switch to VT 1",
        ),
        Key(
            switch,
            "F2",
            lazy.core.change_vt(2),
            desc="Switch to VT 2",
        ),
        Key(
            switch,
            "F3",
            lazy.core.change_vt(3),
            desc="Switch to VT 3",
        ),
        Key(
            switch,
            "F4",
            lazy.core.change_vt(4),
            desc="Switch to VT 4",
        ),
        Key(
            switch,
            "F5",
            lazy.core.change_vt(5),
            desc="Switch to VT 5",
        ),
        Key(
            switch,
            "F6",
            lazy.core.change_vt(6),
            desc="Switch to VT 6",
        ),
    ]


def build_keys(settings: Settings) -> list[Key]:
    return (
        user_menu(settings)
        + system_menu(settings)
        + application(settings)
        + layout(settings)
        + window(settings)
        + group(settings)
        + screen(settings)
        + clipboard(settings)
        + qtile(settings)
        + music(settings)
        + vt(settings)
    )


def build_mouse_buttons(settings):
    cmd = settings["key"]["cmd"]
    return [
        Drag(
            [cmd],
            "Button1",
            lazy.window.set_position_floating(),
            start=lazy.window.get_position(),
        ),
        Drag(
            [cmd],
            "Button3",
            lazy.window.set_size_floating(),
            start=lazy.window.get_size(),
        ),
        Click([cmd], "Button2", lazy.window.bring_to_front()),
    ]
