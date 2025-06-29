import re
from libqtile.config import Match, Rule  # type: ignore
from libqtile.lazy import lazy  # type: ignore
from libqtile.config import Key, Group  # type: ignore

from .settings.typedefs import Settings


group_config = {
    "WWW": {"layout": "monadtall"},
    "BRAIN": {"layout": "max"},
    "CODE": {"layout": "max"},
    "TERM": {"layout": "monadtall"},
    "DOC": {"layout": "monadtall"},
    "CHAT": {"layout": "monadtall"},
    "MUS": {"layout": "monadtall"},
    "VID": {"layout": "monadtall"},
    "GFX": {"layout": "max"},
}

wmclass_group = {
    "WWW": ["brave-browser|chromium|firefox"],
    "BRAIN": ["obsidian"],
    "CODE": ["code-url-handler"],
    "GFX": [
        "Darktable",
        r"Gimp-\d+\.\d+",
        r"org\.inkscape\.Inkscape",
    ],
    "CHAT": ["discord"],
}

SUPERSCRIPT = ["⁰", "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹"]
SUBSCRIPT = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]

DECORATION = "superscript"


def decoration(group_idx: int) -> str:
    if DECORATION == "superscript":
        return SUPERSCRIPT[group_idx]
    elif DECORATION == "subscript":
        return SUBSCRIPT[group_idx]
    else:
        return ""


def build_groups(settings: Settings) -> list[Group]:
    groups = []
    for idx, (name, kwargs) in enumerate(group_config.items(), 1):
        matches = build_match(name)
        if matches:
            kwargs["matches"] = matches
        group = Group(
            name=str(idx),
            label=name + decoration(idx),
            **kwargs,
        )
        groups.append(group)
    return groups


def build_group_keys(settings: Settings) -> list[Key]:
    cmd = settings["key"]["cmd"]
    shift = settings["key"]["shift"]
    keys = []
    for idx, _ in enumerate(group_config.keys(), 1):
        name = str(idx)
        keys.append(
            Key(
                [cmd],
                str(idx),
                lazy.group[name].toscreen(toggle=True),
                desc=f"Switch to group {name}",
            )
        )
        keys.append(
            Key(
                [cmd, shift],
                str(idx),
                lazy.window.togroup(name),
                desc=f"Send current window to group {name}",
            )
        )
    return keys


def build_match(group: str) -> list[Rule]:
    matches = []
    regexes = wmclass_group.get(group, [])
    if regexes:
        for regex in regexes:
            match = Match(wm_class=re.compile(regex))
            matches.append(match)
    return matches
