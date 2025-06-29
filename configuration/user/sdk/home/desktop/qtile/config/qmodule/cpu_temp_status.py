from libqtile.widget import base  # type: ignore
from qtile_extras.widget import ThermalSensor  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from ..qwidget.icon import MDIcon
from .base import WidgetModule
from .context import ModuleContext


class CPUTempStatus(WidgetModule):
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

        temp_props = {
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            temp_props,
            self.context.props.pop("temperature", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        cpu_temp = ThermalSensor(**props)

        temp_icon_props = {
            "name": "cpu_temp",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            temp_icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        cpu_temp_icon = MDIcon(**props)

        widgets = [
            cpu_temp_icon,
            cpu_temp,
        ]
        return widgets
