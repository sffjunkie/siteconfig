import os
import sys

from libqtile import __path__ as libqtile_path  # type: ignore
from libqtile import layout  # type: ignore
from libqtile.backend.wayland import InputConfig  # type: ignore
from libqtile.config import Screen  # type: ignore
from libqtile.log_utils import logger  # type: ignore

from . import bars
from . import floating
from . import group
from . import kbdmouse
from . import scratchpad
from . import wallpaper
from .secret.loader import load_secrets
from .settings.loader import load_settings
from .theme.loader import load_theme

is_nixos = os.path.exists("/etc/NIXOS")

logger.warning(f"python prefix: {sys.prefix}")
logger.warning(f"python version: {sys.version}")
logger.warning(f"python platform: {sys.platform}")
logger.warning(f"python path: {sys.path}")
logger.warning(f"libqtile path: {libqtile_path}")

secrets = load_secrets()
settings = load_settings()
theme = load_theme()

bar_defs = bars.build_bars(settings=settings, theme=theme)
screens = [
    Screen(
        **bar_defs,
        wallpaper=wallpaper.get_wallpaper(),
        wallpaper_mode="fill",
    ),
]

groups = group.build_groups(settings) + scratchpad.build_scratchpads(settings)

keys = (
    kbdmouse.build_keys(settings)
    + group.build_group_keys(settings)
    + scratchpad.build_keys(settings)
)
mouse = kbdmouse.build_mouse_buttons(settings)

floating_layout = floating.build_layout(theme=theme)
layouts = [
    layout.MonadTall(**theme["layout"]),
    layout.Max(**theme["layout"]),
]

auto_fullscreen = True
bring_front_click = "floating_only"
cursor_warp = False
extension_defaults = theme["extension"].copy()
focus_on_window_activation = "smart"
follow_mouse_focus = False
widget_defaults = theme["widget"].copy()
wmname = "QTile"


# to get ids use `qtile cmd-obj -o core -f get_inputs`
wl_input_rules = {
    "1452:591:Keychron Keychron K1": InputConfig(
        kb_layout="hyper_super",  # configuration/module/user/wayland/keyboard/hyper_super
        kb_options="altwin:swap_lalt_lwin",
    ),
    "1133:45082:MX Anywhere 2S Mouse": InputConfig(natural_scroll=True),
    "1386:828:Wacom Intuos PT S 2 Finger": InputConfig(tap=True),
}

wl_xcursor_size = 32
