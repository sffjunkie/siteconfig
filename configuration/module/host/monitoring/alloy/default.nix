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

  envFile = pkgs.writeTextFile {
    name = "alloy.env";
    text = ''
      CUSTOM_ARGS=--server.http.listen-addr=0.0.0.0:${toString port}
    '';
  };

  configDebugging = ''
    livedebugging{}
  '';

  loki = ''
    loki.write "looniversity" {
        endpoint {
            url = "http://${lokiHost}:${toString lokiPort}/loki/api/v1/push"
        }
    }
  '';

  metrics = pkgs.callPackage ./metrics.nix { inherit config lib; };
  logs = pkgs.callPackage ./logs.nix { inherit config lib; };

  alloyConfigElems = [
    loki
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
    livedebug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable live debugging";
    };
    zfsSupport = mkEnableOption "alloy_zfs";
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
