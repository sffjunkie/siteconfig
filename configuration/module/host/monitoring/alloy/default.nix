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

  configDebugging = ''
    livedebugging{}
  '';

  loki = lib.traceVal ''
    loki.write "looniversity" {
        endpoint {
            url = "http://${lokiHost}:${toString lokiPort}/loki/api/v1/push"
        }
    }
  '';

  metrics = pkgs.callPackage ./metrics.nix { inherit lib; };
  logs = pkgs.callPackage ./logs.nix { inherit lib; };

  alloyConfigElems = [
    loki
    logs
    metrics
    (lib.optional cfg.livedebug configDebugging)
  ];

  alloyConfig = (lib.concatStringsSep "\n" alloyConfigElems);

  configFile = pkgs.writeTextFile {
    name = "alloy_config";
    text = (lib.traceVal alloyConfig);
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
    };
    networking.firewall.allowedTCPPorts = [ port ];
  };
}
