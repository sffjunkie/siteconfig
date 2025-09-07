{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.monitoring.alloy;
  port = lib.network.serviceHandlerMainPort config "alloy";
  lokiHost = lib.network.serviceHandlerHost config "loki";
  lokiPort = lib.network.serviceHandlerMainPort config "loki";
  prometheusHost = lib.network.serviceHandlerHost config "prometheus";
  prometheusPort = lib.network.serviceHandlerMainPort config "prometheus";

  envFile = pkgs.writeTextFile {
    name = "alloy.env";
    text = ''
      CUSTOM_ARGS=--server.http.listen-addr=0.0.0.0:${toString port}
    '';
  };

  loki = ''
    loki.write "looniversity" {
        endpoint {
            url = "http://${lokiHost}:${toString lokiPort}/loki/api/v1/push"
        }
    }
  '';

  prometheus = ''
    prometheus.remote_write "looniversity" {
      endpoint {
        url = "http://${prometheusHost}:${toString prometheusPort}/api/v1/write"
      }
    }
  '';

  logs = pkgs.callPackage ./logs.nix {
    inherit config lib;
    node = config.looniversity.monitoring.alloy.node;
  };
  metrics = pkgs.callPackage ./metrics.nix { inherit config lib; };

  configDebugging = ''
    livedebugging{}
  '';

  alloyConfigElems = [
    loki
    prometheus
    logs
    metrics
  ]
  ++ lib.optional cfg.livedebug configDebugging;

  alloyConfig = lib.concatStringsSep "\n" alloyConfigElems;

  configFile = pkgs.writeTextFile {
    name = "alloy_config";
    text = alloyConfig;
  };

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.monitoring.alloy = {
    enable = mkEnableOption "alloy";
    node = mkOption {
      type = types.str;
      default = "unknown";
    };
    livedebug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable live debugging";
    };
  };

  config = mkIf cfg.enable {
    services.alloy = {
      enable = true;
      configPath = "${toString configFile}";
      environmentFile = "${toString envFile}";
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
