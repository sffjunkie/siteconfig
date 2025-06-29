import os
from pathlib import Path

import yaml  # type: ignore

from libqtile.log_utils import logger  # type: ignore

from .typedefs import Settings


def _settings_path(filepath: Path | None = None) -> Path | None:
    if filepath is not None and filepath.is_absolute():
        settings_path = filepath
    else:
        if filepath is None:
            filepath = Path("settings.yaml")

        xdg_config = Path(
            os.environ.get(
                "XDG_CONFIG_HOME",
                os.path.expanduser("~/.config"),
            )
        )
        settings_path = xdg_config / "desktop" / filepath

    if not settings_path.exists():
        logger.warning(f"No settings found in {settings_path}")
        settings_path = None

    return settings_path


def _settings_yaml(filepath: Path | None = None) -> dict | None:
    settings = None
    if filepath is not None:
        try:
            with open(filepath, "r") as fp:
                settings = yaml.load(fp, yaml.SafeLoader)
        except (IOError, yaml.YAMLError):
            settings = None

    return settings


def load_settings(filepath: Path | None = None) -> Settings:
    settings_path = _settings_path(filepath)
    if settings_path is None:
        settings_yaml = {}
    else:
        # logger.warning(f"Loading settings from {settings_path}")
        settings_yaml = _settings_yaml(settings_path) or {}

    default_settings_path = _settings_path(Path("default_settings.yaml"))
    # logger.warning(f"Default Settings Path {default_settings_path}")
    default_settings_yaml = _settings_yaml(default_settings_path) or {}

    default_settings_yaml.update(settings_yaml)

    # logger.warning(f"Settings {default_settings_yaml}")

    return default_settings_yaml
