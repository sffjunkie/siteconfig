{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.environment.gnome;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.desktop.environment.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.defaultSession = "gnome";
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
