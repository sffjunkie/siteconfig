# ports: 27017 - 27020
{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.monitoring.grafana;
  nginxCfg = config.services.nginx;
  host = lib.network.serviceHandlerHost config "grafana";
  port = lib.network.serviceHandlerMainPort config "grafana";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.grafana = {
    enable = mkEnableOption "grafana";
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings = {
        server = {
          domain = "grafana.${lib.network.domainName config}";
          http_port = port;
          http_addr = host;
          protocol = "https";
        };

        analytics = {
          reporting_enabled = false;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];

    services.nginx = lib.mkIf nginxCfg.enable {
      virtualHosts.${config.services.grafana.settings.server.domain} = {
        locations."/" = {
          proxyPass = "http://${host}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
