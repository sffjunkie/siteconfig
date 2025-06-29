from libqtile.lazy import lazy  # type: ignore
from libqtile.widget import base  # type: ignore
from qtile_extras.widget import CPU  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .base import WidgetModule
from .context import ModuleContext
from ..qwidget.icon import MDIcon
from ..terminal import terminal_run_command, terminal_from_env


class CPUUsageStatus(WidgetModule):
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

        htop = terminal_run_command(terminal_from_env(), ["htop"])

        usage_props = {
            "format": "{load_percent:4.1f}%",
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
            "mouse_callbacks": {
                "Button1": lazy.spawn(htop),
            },
        }

        props = self.context.merge_parameters(
            usage_props,
            self.context.props.pop("usage", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        cpu_usage = CPU(**props)

        usage_icon_props = {
            "name": "cpu_usage",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            "padding": 8,
            "background": f"{background_color}00",
            "mouse_callbacks": {
                "Button1": lazy.spawn(htop),
            },
        }

        props = self.context.merge_parameters(
            usage_icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        cpu_usage_icon = MDIcon(**props)

        widgets = [
            cpu_usage_icon,
            cpu_usage,
        ]
        return widgets
