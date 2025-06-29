{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.dunst;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.looniversity.desktop.dunst = {
    enable = mkEnableOption "dunst user service";
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      waylandDisplay = "wayland-0";
      settings = {
        global = {
          font = mkIf (!config.stylix.targets.dunst.enable) "Hack Nerd Font 13";
          width = 500;
          height = 300;
          origin = "top-right";
          offset = "10x54";
          notification_limit = 20;
          transparency = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          markup = "full";
          icon_position = "left";
          min_icon_size = 32;
          max_icon_size = 128;
          vertical_alignment = "top";
        };
      };
    };
  };
}
