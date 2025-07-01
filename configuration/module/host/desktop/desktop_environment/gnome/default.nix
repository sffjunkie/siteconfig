{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.environment.gnome;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.desktop.environment.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.defaultSession = "gnome";
      displayManager.gdm = enabled;
      desktopManager.gnome = enabled;
    };
  };
}
