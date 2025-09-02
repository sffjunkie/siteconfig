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
          grpc_listen_port = 9096;
        };

        common = {
          path_prefix = "/tmp/loki";
          storage = {
            filesystem = {
              directory = "/tmp/loki/chunks";
            };
          };
          replication_factor = 1;
          ring = {
            instance_addr = "127.0.0.1";
            kvstore = {
              store = "inmemory";
            };
          };
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

        storage_config = {
          filesystem = {
            directory = "/tmp/loki/chunks";
          };
        };
      };
      extraFlags = [ "--server.http-listen-port=${toString port}" ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
