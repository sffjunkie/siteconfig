{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.web_server;
  inherit (lib) mkEnableOption mkIf optionals;
in
{
  options.looniversity.role.web_server = {
    enable = mkEnableOption "web_server role";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
