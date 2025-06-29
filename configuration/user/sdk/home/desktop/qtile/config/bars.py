"""Bars for Qtile"""

import os
from itertools import cycle
from typing import Iterator

from libqtile.log_utils import logger  # type: ignore
from libqtile.bar import Bar as QBar  # type: ignore
from qtile_extras.widget import Spacer as QSpacer  # type: ignore

from .qbar.context import BarContext, BarPosition

from .qmodule.base import WidgetModule
from .qmodule.bluetooth import Bluetooth
from .qmodule.context import ModuleContext
from .qmodule.cpu_temp_status import CPUTempStatus
from .qmodule.cpu_usage_status import CPUUsageStatus
from .qmodule.current_layout import CurrentLayout
from .qmodule.date_time import DateTime
from .qmodule.group_box import GroupBox
from .qmodule.memory_status import MemoryStatus
from .qmodule.music_status import MusicStatus
from .qmodule.network_status import NetworkStatus
from .qmodule.separator import Separator
from .qmodule.system_menu import SystemMenu
from .qmodule.user_menu import UserMenu
from .qmodule.volume_status import VolumeStatus
from .qmodule.weather import Weather
from .qmodule.wifi import Wifi
from .qmodule.window_name import WindowName

from .color import contrast_color
from .settings.typedefs import Settings
from .theme.typedefs import Theme


def fg_cycle(iterable, fg_light: str, fg_dark: str) -> Iterator:
    logger.warning(f"*** {fg_light}")
    saved = []
    for element in iterable:
        fg = contrast_color(element, fg_light, fg_dark)
        yield fg
        saved.append(fg)

    while saved:
        for element in saved:
            yield element


def widget_fg_iter(theme: Theme) -> Iterator:
    return fg_cycle(
        theme["color"]["named"]["widget_bg"],
        theme["color"]["named"]["widget_fg_light"],
        theme["color"]["named"]["widget_fg_dark"],
    )


def widget_bg_iter(theme: Theme) -> Iterator:
    return cycle(theme["color"]["named"].get("widget_bg", "000000"))


def build_top_bar(settings: Settings, theme: Theme) -> QBar | None:
    named_colors = theme["color"]["named"]

    bg_iter = widget_bg_iter(theme)

    # fg_iter = widget_fg_iter(theme)
    # logger.warning(next(fg_iter))

    bar_context = BarContext(BarPosition.TOP, settings, theme)

    widgets = []

    separator = Separator(
        ModuleContext(
            bar_context,
            settings,
            theme,
        )
    )

    logger.warning(f"Background {next(bg_iter)} {next(bg_iter)}")
    logger.warning(theme["color"]["named"]["widget_bg"])
    # region start
    start: list[WidgetModule] = [
        UserMenu(
            ModuleContext(
                bar_context,
                settings,
                theme,
                props={
                    "background": next(bg_iter),
                },
            )
        ),
        GroupBox(
            ModuleContext(
                bar_context,
                settings,
                theme,
                props={
                    "background": named_colors["panel_bg"],
                },
            )
        ),
        CurrentLayout(
            ModuleContext(
                bar_context,
                settings,
                theme,
                props={
                    "background": named_colors["panel_bg"],
                },
            )
        ),
    ]

    for idx, group in enumerate(start):
        if idx != 0:
            widgets.extend(separator.widgets())

        widgets.extend(group.widgets(group_id=idx))
    # endregion

    # region middle
    middle: list[WidgetModule] = [
        WindowName(
            ModuleContext(
                bar_context,
                settings,
                theme,
                props={
                    "group": 4,
                    "background": named_colors["panel_bg"],
                },
            )
        ),
    ]

    if middle == []:
        widgets.append(QSpacer(background="#00000000"))
    else:
        widgets.extend(separator.widgets())
        for idx, group in enumerate(middle, start=idx + 1):
            widgets.extend(group.widgets(group_id=idx))
        widgets.extend(separator.widgets())
    # endregion

    # region end
    weather_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
            "weather": {
                "app_key": os.environ.get("OWM_API_KEY", ""),
                "coordinates": {
                    "latitude": os.environ.get("USER_LOCATION_LATITUDE", "51.5"),
                    "longitude": os.environ.get("USER_LOCATION_LONGITUDE", "-0.15"),
                },
                "format": "{main_temp:.1f}/{main_feels_like:.1f}°{units_temperature} {icon}",
            },
        },
    )

    date_time_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
        },
    )

    system_menu_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
        },
    )

    end: list[WidgetModule] = [
        Weather(weather_context),
        DateTime(date_time_context),
        SystemMenu(system_menu_context),
    ]

    group_id = idx + 1
    for idx, group in enumerate(end):
        widgets.extend(group.widgets(group_id=group_id + idx))
        if idx != len(end) - 1:
            widgets.extend(separator.widgets())

    # endregion

    return QBar(
        widgets,
        size=bar_context.height,
        margin=bar_context.margin,
        # background="#00000088",
    )


def build_bottom_bar(settings: Settings, theme: Theme) -> QBar | None:
    bg_iter = widget_bg_iter(theme)

    bar_context = BarContext(BarPosition.BOTTOM, settings, theme)

    widgets = []

    separator = Separator(
        ModuleContext(
            bar_context,
            settings,
            theme,
        )
    )

    # region start
    network_status_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "network": {
                "interface": settings["device"].get("net", "eth0"),
            },
            "background": next(bg_iter),
        },
    )
    memory_status_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "memory": {
                "format": "{MemUsed:6.0f}M/{MemTotal:.0f}M",
            },
            "background": next(bg_iter),
        },
    )
    cpu_usage_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
        },
    )
    cpu_temp_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
        },
    )
    bluetooth_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
            "menu": {
                "menu_font": "JetBrainsMono Nerd Font",
                "menu_fontsize": 16,
                "menu_width": 400,
            },
        },
    )
    wifi_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
            "menu": {
                "menu_font": "JetBrainsMono Nerd Font",
                "menu_fontsize": 16,
                "menu_width": 400,
            },
        },
    )

    start: list[WidgetModule] = [
        NetworkStatus(network_status_context),
        MemoryStatus(memory_status_context),
        CPUUsageStatus(cpu_usage_context),
        CPUTempStatus(cpu_temp_context),
        Bluetooth(bluetooth_context),
        Wifi(wifi_context),
    ]

    for idx, group in enumerate(start):
        if idx != 0:
            widgets.extend(separator.widgets())

        widgets.extend(group.widgets(group_id=idx))
    # endregion

    # region middle
    middle: list[WidgetModule] = []

    if middle == []:
        widgets.append(QSpacer(background="#00000000"))
    else:
        widgets.extend(separator.widgets())
        for idx, group in enumerate(middle, start=idx + 1):
            widgets.extend(group.widgets(group_id=idx))
        widgets.extend(separator.widgets())
    # endregion

    # region end
    music_status_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "music": {
                "status_format": "󰝚 {title} | 󰠃 {artist} | 󰀥 {album} {play_status}",
                "idle_format": "Play queue empty",
            },
            "background": next(bg_iter),
        },
    )

    volume_control = settings["controller"].get("volume", None)
    volume_context = ModuleContext(
        bar_context,
        settings,
        theme,
        props={
            "background": next(bg_iter),
            "volume": {
                "volume_up_command": settings["controller"]["volume"]["up"],
                "volume_down_command": settings["controller"]["volume"]["down"],
                "mute_command": settings["controller"]["volume"]["toggle"],
                "volume_app": settings["app"]["volume"],
            },
        },
    )

    end: list[WidgetModule] = [
        MusicStatus(music_status_context),
        VolumeStatus(volume_context),
    ]

    group_id = idx + 1
    for idx, group in enumerate(end):
        widgets.extend(group.widgets(group_id=group_id + idx))
        if idx != len(end) - 1:
            widgets.extend(separator.widgets())
    # endregion

    return QBar(
        widgets,
        size=bar_context.height,
        margin=bar_context.margin,
        # background="#00000088",
    )


def build_bars(settings: Settings, theme: Theme) -> dict[str, QBar]:
    bars = {}
    bars["top"] = build_top_bar(settings, theme)
    bars["bottom"] = build_bottom_bar(settings, theme)
    return bars
