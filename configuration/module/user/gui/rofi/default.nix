{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.rofi;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.rofi = {
    enable = mkEnableOption "rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
    };

    xdg.configFile."rofi/looniversity.rasi".source = ./looniversity.rasi;
  };
}
