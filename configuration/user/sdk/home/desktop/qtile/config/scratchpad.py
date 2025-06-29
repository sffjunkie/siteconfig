from libqtile.config import DropDown, Key, ScratchPad  # type: ignore
from libqtile.lazy import lazy  # type: ignore

from .anchor import WindowLocation, anchor_window
from .settings.typedefs import Settings
from .terminal import terminal_run_command


def build_scratchpads(settings: Settings) -> list[ScratchPad]:
    ncmpcpp_dimension = anchor_window(
        location=WindowLocation.BottomCenter,
        width=0.5,
        height=0.5,
    )
    home_automation_dimension = anchor_window(
        location=WindowLocation.BottomCenter,
        width=0.5,
        height=0.5,
    )

    return [
        ScratchPad(
            "0",
            dropdowns=[
                DropDown(
                    name="music-player",
                    cmd=terminal_run_command(settings["app"]["terminal"], ["ncmpcpp"]),
                    height=ncmpcpp_dimension.height,
                    width=ncmpcpp_dimension.width,
                    x=ncmpcpp_dimension.x,
                    y=ncmpcpp_dimension.y,
                    opacity=1.0,
                    warp_pointer=False,
                ),
            ],
            single=True,
        ),
        ScratchPad(
            "home-automation",
            dropdowns=[
                DropDown(
                    name="home-automation",
                    cmd=f"{settings['app']['browser']} https://hass.looniversity.net",
                    height=home_automation_dimension.height,
                    width=home_automation_dimension.width,
                    x=home_automation_dimension.x,
                    y=home_automation_dimension.y,
                    opacity=1.0,
                    warp_pointer=False,
                ),
            ],
            single=True,
        ),
    ]


def build_keys(settings: Settings) -> list[Key]:
    Super = settings["key"]["cmd"]
    Alt = settings["key"]["alt"]
    return [
        Key(
            [Super, Alt],
            "F8",
            lazy.group["0"].dropdown_toggle("music-player"),
        ),
        Key(
            [Super, Alt],
            "Home",
            lazy.group["home-automation"].dropdown_toggle("home-automation"),
        ),
    ]
