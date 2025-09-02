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
  port = 2342;

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
