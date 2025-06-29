from libqtile.widget import base  # type: ignore
from qtile_extras.widget import Mpd2  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .base import WidgetModule
from .context import ModuleContext


class MusicStatus(WidgetModule):
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

        mpd2_props = {
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            mpd2_props,
            self.context.props.pop("music", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        mpd2 = Mpd2(**props)

        widgets = [
            mpd2,
        ]
        return widgets
