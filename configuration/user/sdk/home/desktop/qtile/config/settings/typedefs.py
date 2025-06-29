from typing import TypedDict, NotRequired


class Apps(TypedDict):
    brain: NotRequired[str]
    browser: NotRequired[str]
    code: NotRequired[str]
    terminal: NotRequired[str]
    system_menu: NotRequired[str]

    cliboard_copy: NotRequired[str]
    cliboard_delete: NotRequired[str]


class MusicController(TypedDict):
    next: NotRequired[str]
    play: NotRequired[str]
    previous: NotRequired[str]
    stop: NotRequired[str]
    toggle: NotRequired[str]


class VolumeController(TypedDict):
    down: NotRequired[str]
    mute: NotRequired[str]
    toggle: NotRequired[str]
    up: NotRequired[str]


class Controllers(TypedDict):
    music: MusicController
    volume: VolumeController


class Devices(TypedDict):
    net: NotRequired[str]


class Keys(TypedDict):
    alt: NotRequired[str]
    cmd: NotRequired[str]
    ctrl: NotRequired[str]
    hyper: NotRequired[str]
    shift: NotRequired[str]


class Settings(TypedDict):
    app: Apps
    controller: Controllers
    device: Devices
    key: Keys
