# ports: 27017 - 27020
{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.monitoring.promtail;
  port = lib.network.serviceHandlerMainPort config "promtail";
  lokiHost = lib.network.serviceHandlerHost config "loki";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.promtail = {
    enable = mkEnableOption "promtail";
  };

  config = mkIf cfg.enable {
    services.promtail = {
      enable = true;

      configuration = {
        server = {
          http_listen_port = port;
          grpc_listen_port = 0;
        };
        positions = {
          filename = "/tmp/positions.yaml";
        };
        clients = [
          {
            url = "http://${lokiHost}:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
          }
        ];
        scrape_configs = [
          {
            job_name = "journal";
            journal = {
              max_age = "12h";
              labels = {
                job = "systemd-journal";
                host = config.networking.hostName;
              };
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
            ];
          }
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
