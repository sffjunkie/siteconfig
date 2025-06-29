# from libqtile.lazy import lazy  # type: ignore
from libqtile.widget import base  # type: ignore
from qtile_extras.widget import WiFiIcon as QEWifi  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from ..qwidget.icon import MDIcon
from .base import WidgetModule
from .context import ModuleContext


class Wifi(WidgetModule):
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

        wifi_props = {
            "name": "wifi",
            "interface": self.context.settings["device"]["net"],
            "padding": 8,
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "menu_font": self.context.text_font_family,
            "menu_fontsize": self.context.text_font_size,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            wifi_props,
            self.context.props.pop("menu", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        wifi_widget = QEWifi(**props)

        # wifi_icon_props = {
        #     "name": "wifi",
        #     "font": self.context.icon_font_family,
        #     "fontsize": self.context.icon_font_size,
        #     "padding": 8,
        #     "background": f"{background_color}00",
        # }

        # props = self.context.merge_parameters(
        #     wifi_icon_props,
        #     self.context.props.pop("icon", {}),
        # )

        # if decorations is not None:
        #     props["decorations"] = decorations

        # wifi_icon = MDIcon(**props)

        widgets = [
            wifi_widget,
            # wifi_icon,
        ]
        return widgets
