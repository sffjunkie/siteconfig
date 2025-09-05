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
  port = lib.network.serviceHandlerMainPort config "loki";

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
        auth_enabled = false;

        server = {
          http_listen_port = port;
          # grpc_listen_port = 9096;
        };

        ingester = {
          lifecycler = {
            address = "127.0.0.1";
            ring = {
              kvstore = {
                store = "inmemory";
              };
              replication_factor = 1;
            };
            final_sleep = "0s";
          };
          chunk_idle_period = "5m";
          chunk_retain_period = "30s";
        };

        common = {
          path_prefix = config.services.loki.dataDir;
        };

        schema_config = {
          configs = [
            {
              from = "2020-05-15";
              store = "tsdb";
              object_store = "filesystem";
              schema = "v13";
              index = {
                prefix = "index_";
                period = "24h";
              };
            }
          ];
        };

        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
        };

        query_scheduler = {
          max_outstanding_requests_per_tenant = 32768;
        };

        querier = {
          max_concurrent = 16;
        };

        analytics = {
          reporting_enabled = false;
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
