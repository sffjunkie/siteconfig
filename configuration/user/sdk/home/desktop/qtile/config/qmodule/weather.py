from libqtile.widget import base  # type: ignore
from qtile_extras.widget import OpenWeather  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .context import ModuleContext
from .base import WidgetModule


class Weather(WidgetModule):
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

        weather_props = {
            "padding": 12,
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            weather_props,
            self.context.props.pop("weather", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        weather = OpenWeather(**props)

        widgets = [weather]
        return widgets
