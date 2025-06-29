{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.lockscreen.swaylock;
  swaylock = "${pkgs.swaylock}/bin/swaylock -fF";
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.wayland.lockscreen.swaylock = {
    enable = mkEnableOption "swaylock/swayidle lockscreen";
  };

  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      # style set by stylix
    };

    services.swayidle = {
      enable = true;
      extraArgs = [
        "-d"
      ];
      timeouts = [
        {
          timeout = 180;
          command = swaylock;
        }
        {
          timeout = 300;
          command = "${pkgs.coreutils}/bin/sleep 1; ${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          command = swaylock;
        }
        {
          event = "lock";
          command = swaylock;
        }
      ];
    };
  };
}
