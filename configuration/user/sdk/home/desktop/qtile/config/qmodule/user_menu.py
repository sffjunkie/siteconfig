import os
from libqtile.lazy import lazy  # type: ignore
from libqtile.widget import base  # type: ignore
from qtile_extras.widget import TextBox  # type: ignore
from qtile_extras.widget.decorations import RectDecoration  # type: ignore

from .context import ModuleContext
from .base import WidgetModule
from ..qwidget.icon import MDIcon

# from libqtile.log_utils import logger  # type: ignore


class UserMenu(WidgetModule):
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
                    # padding_x=8,
                )
            ]

        icon_props = {
            "name": "user",
            "font": self.context.icon_font_family,
            "fontsize": self.context.icon_font_size,
            # "width": self.context.bar.height,
            "padding": 8,
            "mouse_callbacks": {"Button1": lazy.spawn("user-menu")},
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            icon_props,
            self.context.props.pop("icon", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        icon = MDIcon(**props)

        username_props = {
            "text": os.environ["USER"],
            "font": self.context.text_font_family,
            "fontsize": self.context.text_font_size,
            "padding": 8,
            "mouse_callbacks": {"Button1": lazy.spawn("user-menu")},
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            username_props,
            self.context.props.pop("username", {}),
        )

        if decorations is not None:
            props["decorations"] = decorations

        username = TextBox(**props)

        widgets = [icon, username]
        return widgets
