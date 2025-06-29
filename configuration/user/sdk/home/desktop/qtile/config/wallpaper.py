import configparser
import os
from pathlib import Path


def get_wallpaper():
    return get_waypaper_wallpaper()


def get_waypaper_wallpaper() -> str | None:
    xdg_config = os.environ.get(
        "XDG_CONFIG_HOME",
        os.path.expanduser("~/.config"),
    )

    if xdg_config is None:
        return None

    config_file = Path(xdg_config) / "waypaper" / "config.ini"

    parser = configparser.ConfigParser()
    with config_file.open() as fp:
        parser.read_file(fp)

    try:
        return parser["Settings"]["wallpaper"]
    except KeyError:
        return None
