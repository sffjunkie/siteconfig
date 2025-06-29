from libqtile.widget import base  # type: ignore
from qtile_extras.widget import CurrentLayout as QCurrentLayout  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .base import WidgetModule
from .context import ModuleContext


class CurrentLayout(WidgetModule):
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
        # if group_id != -1:
        decorations = [
            RectDecoration(
                colour=f"{background_color}{self.context.bar.opacity_str}",
                radius=5,
                filled=True,
                group=True,
                group_id=10,
            )
        ]

        current_layout_props = {
            "padding": 12,
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "foreground": self.context.theme["color"]["named"]["group_active_fg"],
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            current_layout_props,
            self.context.props.pop("layout", {}),
        )

        current_layout = QCurrentLayout(
            **props,
            decorations=decorations,
        )

        widgets = [current_layout]
        return widgets
