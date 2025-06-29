from libqtile.widget import base  # type: ignore
from qtile_extras.widget import Spacer as QSpacer  # type: ignore
from qtile_extras.widget import WindowName as QWindowName  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .base import WidgetModule
from .context import ModuleContext


class WindowName(WidgetModule):
    def __init__(
        self,
        context: ModuleContext,
    ):
        self.context = context

    def widgets(self, group_id: int = -1) -> list[base._Widget]:
        background_color = self.context.props.get(
            "background", self.context.bar.background
        )

        window_name_props = {
            "padding": 12,
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "foreground": self.context.theme["color"]["named"]["group_active_fg"],
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            window_name_props,
            self.context.props.pop("name", {}),
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

        widgets = [
            QSpacer(
                background=f"{background_color}00",
                decorations=decorations,
            ),
            QWindowName(
                **props,
                decorations=decorations,
            ),
            QSpacer(
                background=f"{background_color}00",
                decorations=decorations,
            ),
        ]
        return widgets
