from libqtile.widget import base  # type: ignore
from qtile_extras.widget import Sep  # type: ignore

from .base import WidgetModule
from .context import ModuleContext


class Separator(WidgetModule):
    def __init__(
        self,
        context: ModuleContext,
    ):
        self.context = context

    def widgets(self, group_id: int = -1) -> list[base._Widget]:
        background_color = self.context.props.get(
            "background", self.context.bar.background
        )

        separator_props = {
            "padding": 12,
            "linewidth": 0,
            "background": f"{background_color}00",
        }

        props = self.context.merge_parameters(
            separator_props,
            self.context.props.pop("separator", {}),
        )

        separator = Sep(**props)

        widgets = [separator]
        return widgets
