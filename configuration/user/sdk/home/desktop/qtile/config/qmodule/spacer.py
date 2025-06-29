from libqtile.widget import base  # type: ignore
from qtile_extras.widget import Spacer as QSpacer  # type: ignore
from .base import WidgetModule
from .context import ModuleContext


class Spacer(WidgetModule):
    def __init__(
        self,
        context: ModuleContext,
    ):
        self.context = context

    def widgets(self, group_id: int = -1) -> list[base._Widget]:
        background_color = self.context.props.get(
            "background", self.context.bar.background
        )
        background = f"{background_color}{self.context.bar.opacity_str}"

        spacer_props = {
            "background": background,
        }

        props = self.context.merge_parameters(
            spacer_props,
            self.context.props.pop("layout", {}),
        )

        spacer = QSpacer(**props)

        widgets = [spacer]
        return widgets
