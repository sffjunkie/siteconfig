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
          http_addr = "127.0.0.1";
        };

        analytics = {
          reporting_enabled = false;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];

    # services.nginx = {
    #   virtualHosts.${config.services.grafana.domain} = {
    #     locations."/" = {
    #       proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
    #       proxyWebsockets = true;
    #     };
    #   };
    # };
  };
}
