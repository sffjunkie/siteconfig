{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.notification.libnotify;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.desktop.notification.libnotify = {
    enable = mkEnableOption "libnotify";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.libnotify
    ];
  };
}
