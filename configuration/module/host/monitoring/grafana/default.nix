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

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.grafana = {
    enable = mkEnableOption "grafana";
  };

  config = mkIf cfg.enable {
    services.grafana = {
      enable = true;
      domain = "grafana.${lib.network.domainName config}";
      port = 2342;
      addr = "127.0.0.1";
    };

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
