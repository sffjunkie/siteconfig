from typing import Protocol

from libqtile.widget import base  # type: ignore

from ..qmodule.context import ModuleContext


class WidgetModule(Protocol):
    def __init__(
        self,
        context: ModuleContext,
    ): ...

    def widgets(self, group_id: int = -1) -> list[base._Widget]: ...
