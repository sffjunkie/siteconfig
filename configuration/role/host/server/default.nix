{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.server;
  inherit (lib)
    enabled
    mkEnableOption
    mkIf
    optionals
    ;
in
{
  options.looniversity.role.server = {
    enable = mkEnableOption "server role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      # profile.hardened= enabled;

      service.autoUpgrade = enabled;
      service.fail2ban = enabled;
      network.service.sshd = enabled;
    };

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
      ];
    };

    environment.systemPackages = [
      pkgs.pinentry-curses
    ];
  };
}
