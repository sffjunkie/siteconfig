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
  port = lib.traceVal (lib.network.serviceHandlerMainPort config "loki");

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.loki = {
    enable = mkEnableOption "loki";
  };

  config = mkIf cfg.enable {
    services.loki = {
      enable = true;
      configuration = {
        analytics = {
          reporting_enabled = false;
        };
      };
      extraFlags = [ "--server.http-listen-port=${toString port}" ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
