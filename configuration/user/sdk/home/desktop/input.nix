{
  config,
  lib,
  pkgs,
  ...
}:
let
  settingsFormat = pkgs.formats.yaml { };
  settings = {
    "keyboard" =
      { }
      // lib.optionalAttrs (config.looniversity.keyboard.hyper_super.enable) {
        "1452:591:Keychron Keychron K1" = {
          kb_layout = "hyper_super"; # configuration/module/home/wayland/keyboard/hyper_super
          kb_options = "altwin:swap_lalt_lwin";
        };
      };
    "pointer" = {
      "1133:45082:MX Anywhere 2S Mouse" = {
        natural_scroll = true;
      };
      "1386:828:Wacom Intuos PT S 2 Finger" = {
        tap = true;
      };
    };
  };
in
{
  config = {
    xdg.configFile."desktop/input.yaml".source = settingsFormat.generate "desktop-input.yaml" settings;
  };
}
