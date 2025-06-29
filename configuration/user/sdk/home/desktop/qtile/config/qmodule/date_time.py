from libqtile.widget import base  # type: ignore
from qtile_extras.widget import Clock  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .base import WidgetModule
from .context import ModuleContext
from ..qwidget.icon import MDIcon


class DateTime(WidgetModule):
    def __init__(
        self,
        context: ModuleContext,
    ):
        self.context = context

    def widgets(self, group_id: int = -1) -> list[base._Widget]:
        background_color = self.context.props.get(
            "background", self.context.bar.background
        )

        # bar_height = self.context.bar.height

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

        date_text_props = {
            "format": "%a %Y-%m-%d",
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            date_text_props,
            self.context.props.pop("date", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        date_text = Clock(**props)

        date_icon_props = {
            "name": "calendar",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            date_icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        date_icon = MDIcon(**props)

        time_text_props = {
            "format": "%H:%M",
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            time_text_props,
            self.context.props.pop("time", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        time_text = Clock(**props)

        time_icon_props = {
            "name": "clock",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            time_icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        time_icon = MDIcon(**props)

        widgets = [date_text, date_icon, time_text, time_icon]
        return widgets
