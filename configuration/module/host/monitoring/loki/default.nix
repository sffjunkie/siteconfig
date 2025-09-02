# ports: 27017 - 27020
{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.monitoring.loki;
  port = 9002;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.loki = {
    enable = mkEnableOption "loki";
  };

  config = mkIf cfg.enable {
    services.loki = {
      enable = true;
      extraFlags = [ "--server.http-listen-port=${port}" ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
