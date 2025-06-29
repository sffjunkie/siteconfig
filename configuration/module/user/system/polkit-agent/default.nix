{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.looniversity.system.polkit-agent;
in
{
  options.looniversity.system.polkit-agent = {
    enable = mkEnableOption "polkit-agent";

    systemdTarget = mkOption {
      type = types.str;
      default = "graphical-session.target";
      example = "wayland-session.target";
      description = ''
        Systemd target to bind to.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.polkit_gnome
    ];

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      Service = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
      Install = {
        WantedBy = [ cfg.systemdTarget ];
      };
    };
  };
}
