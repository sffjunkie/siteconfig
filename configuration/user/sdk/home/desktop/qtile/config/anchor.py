from dataclasses import dataclass
from enum import Enum, auto
from typing import Annotated


@dataclass
class FloatRange:
    min: float
    max: float


ScreenFraction = Annotated[float, FloatRange(min=0.0, max=1.0)]

Margin2 = tuple[ScreenFraction, ScreenFraction]
Margin4 = tuple[ScreenFraction, ScreenFraction, ScreenFraction, ScreenFraction]

Margin = ScreenFraction | Margin2 | Margin4


@dataclass
class WindowPosition:
    x: float
    y: float
    width: float
    height: float


class WindowLocation(Enum):
    Left = auto()
    Right = auto()
    Top = auto()
    Bottom = auto()
    TopLeft = auto()
    TopCenter = auto()
    TopRight = auto()
    BottomLeft = auto()
    BottomCenter = auto()
    BottomRight = auto()
    Centered = auto()


def clamp(value: ScreenFraction) -> ScreenFraction:
    if value < 0.0:
        return 0.0
    elif value > 1.0:
        return 1.0

    return value


def anchor_window(
    location: WindowLocation,
    width: ScreenFraction,
    height: ScreenFraction,
    margin: Margin = 0.0,
) -> WindowPosition:
    # if isinstance(margin, tuple):
    if width + (2.0 * margin) > 1.0:
        width = 1.0 - (2.0 * margin)

    if height + 2.0 * margin > 1.0:
        height = 1.0 - (2.0 * margin)

    if location == WindowLocation.Left:
        return WindowPosition(
            x=0.0 + margin,
            y=0.0 + margin,
            width=width,
            height=1.0 - (2.0 * margin),
        )
    elif location == WindowLocation.Right:
        return WindowPosition(
            x=1.0 - width - margin,
            y=0.0 + margin,
            width=width,
            height=1.0 - (2.0 * margin),
        )
    elif location == WindowLocation.Top:
        return WindowPosition(
            x=0.0 + margin,
            y=0.0 + margin,
            width=1.0 - (2.0 * margin),
            height=height,
        )
    elif location == WindowLocation.Bottom:
        return WindowPosition(
            x=0.0 + margin,
            y=1.0 - height - margin,
            width=1.0,
            height=height,
        )
    elif location == WindowLocation.TopLeft:
        return WindowPosition(
            x=0.0 + margin,
            y=0.0 + margin,
            width=width,
            height=height,
        )
    elif location == WindowLocation.TopCenter:
        return WindowPosition(
            x=(1.0 - width) / 2.0,
            y=0.0 + margin,
            width=width,
            height=height,
        )
    elif location == WindowLocation.TopRight:
        return WindowPosition(
            x=1.0 - width - margin,
            y=0.0 + margin,
            width=width,
            height=height,
        )
    elif location == WindowLocation.BottomLeft:
        return WindowPosition(
            x=0.0 + margin,
            y=1.0 - height - margin,
            width=width,
            height=height,
        )
    elif location == WindowLocation.BottomCenter:
        return WindowPosition(
            x=(1.0 - width) / 2.0,
            y=1.0 - height - margin,
            width=width,
            height=height,
        )
    elif location == WindowLocation.BottomRight:
        return WindowPosition(
            x=1.0 - width - margin,
            y=1.0 - height - margin,
            width=width,
            height=height,
        )
    elif location == WindowLocation.Centered:
        return WindowPosition(
            x=(1.0 - width) / 2.0,
            y=(1.0 - height) / 2.0,
            width=width,
            height=height,
        )
