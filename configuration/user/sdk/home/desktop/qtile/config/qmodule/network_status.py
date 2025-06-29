from libqtile.log_utils import logger  # type: ignore
from libqtile.lazy import lazy  # type: ignore
from libqtile.widget import base  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .context import ModuleContext
from .base import WidgetModule
from ..qwidget.icon import MDIcon
from ..qwidget.net_min import NetMin
from ..terminal import terminal_run_command, terminal_from_env


class NetworkStatus(WidgetModule):
    def __init__(
        self,
        context: ModuleContext,
    ):
        self.context = context

    def widgets(self, group_id: int = -1) -> list[base._Widget]:
        background_color = self.context.props.get(
            "background", self.context.bar.background
        )

        decorations = None
        if group_id != -1:
            decorations = [
                RectDecoration(
                    colour=f"{background_color}{self.context.bar.opacity_str}",
                    radius=5,
                    filled=True,
                    group=True,
                    group_id=group_id,
                )
            ]

        network = self.context.props.pop("network", {})

        slurm = terminal_run_command(
            terminal_from_env(),
            [
                "slurm",
                "-i",
                network.get("interface", "wlp3s0"),
            ],
        )

        up_props = {
            "format": "{up:4.0f}{up_suffix:<2}",
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
            "mouse_callbacks": {
                "Button1": lazy.spawn(slurm),
            },
        }

        props = self.context.merge_parameters(
            up_props,
            self.context.props.pop("up", {}),
            self.context.props.pop("network", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        up = NetMin(**props)

        up_icon_props = {
            "name": "net_up",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            "padding": 8,
            "background": f"{background_color}00",
            "mouse_callbacks": {
                "Button1": lazy.spawn(slurm),
            },
        }

        props = self.context.merge_parameters(
            up_icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        up_icon = MDIcon(**props)

        down_props = {
            "format": "{down:4.0f}{down_suffix:<2}",
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
            "mouse_callbacks": {
                "Button1": lazy.spawn(slurm),
            },
        }

        props = self.context.merge_parameters(
            down_props,
            self.context.props.pop("down", {}),
            self.context.props.pop("network", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        down = NetMin(**props)

        down_icon_props = {
            "name": "net_down",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            "padding": 8,
            "background": f"{background_color}00",
            "mouse_callbacks": {
                "Button1": lazy.spawn(slurm),
            },
        }

        props = self.context.merge_parameters(
            down_icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        down_icon = MDIcon(**props)

        widgets = [
            up_icon,
            up,
            down_icon,
            down,
        ]
        return widgets
