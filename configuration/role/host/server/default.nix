{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.server;
  inherit (lib) mkEnableOption mkIf optionals;
in
{
  options.looniversity.role.server = {
    enable = mkEnableOption "server role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      # profile.hardened.enable = true;

      service.autoUpgrade.enable = true;
      service.fail2ban.enable = true;
      network.service.sshd.enable = true;
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
