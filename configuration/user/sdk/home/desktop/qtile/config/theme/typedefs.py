from pathlib import Path
from typing import TypedDict, NotRequired


PropertyDefinitions = dict[str, str | int]

# region bar
BarLocation = str


class BarDefinition(TypedDict):
    height: int
    opacity: float
    margin: tuple[int, int, int, int]


BarDefinitions = dict[BarLocation, BarDefinition]
# endregion

# region color
Color = str


class Base16Colors(TypedDict):
    base00: str
    base01: str
    base02: str
    base03: str
    base04: str
    base05: str
    base06: str
    base07: str
    base08: str
    base09: str
    base0A: str
    base0B: str
    base0C: str
    base0D: str
    base0E: str
    base0F: str


class Base16(TypedDict):
    colors: NotRequired[Base16Colors]
    scheme_name: str | None
    scheme_dir: str | None


class NamedColors(TypedDict):
    group_current_fg: NotRequired[Color]
    group_current_bg: NotRequired[Color]
    group_active_fg: NotRequired[Color]
    group_active_bg: NotRequired[Color]
    group_inactive_fg: NotRequired[Color]
    group_inactive_bg: NotRequired[Color]

    panel_fg: NotRequired[Color]
    panel_bg: NotRequired[Color]

    widget_bg: NotRequired[list[str]]
    widget_fg_dark: NotRequired[Color]
    widget_fg_light: NotRequired[Color]

    window_border: NotRequired[Color]


class Colors(TypedDict):
    base16: Base16
    named: NamedColors


# endregion

# region font
FontType = str


class FontDefinition(TypedDict):
    family: str
    size: int


FontDefinitions = dict[FontType, FontDefinition]
# endregion


class Theme(TypedDict):
    bar: BarDefinitions
    color: Colors
    extension: PropertyDefinitions
    font: FontDefinitions
    layout: PropertyDefinitions
    logo: str
    path: Path | None
    widget: PropertyDefinitions
