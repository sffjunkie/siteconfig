{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.display_manager.greetd;

  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
in
{
  options.looniversity.desktop.display_manager.greetd = {
    enable = mkEnableOption "greetd display manager";
  };

  config = mkIf cfg.enable {
    services.greetd.enable = true;

    systemd.services.greetd.serviceConfig = {
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
