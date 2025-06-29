{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.lockscreen.swaylock;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.wayland.lockscreen.swaylock = {
    enable = mkEnableOption "swaylock";
  };

  config = mkIf cfg.enable {
    security.pam.services.swaylock.text = ''
      auth include login
    '';
  };
}
