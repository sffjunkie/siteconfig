{
  config,
  lib,
  pkgs,
  types,
  ...
}:
let
  cfg = config.looniversity.monitoring.alloy;
  port = lib.network.serviceHandlerMainPort config "alloy";

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

  alloyConfigElems = [
    loki
    (import ./logs.nix)
    (import ./metrics.nix)
  ]
  ++ (lib.optional cfg.livedebug configDebugging);

  alloyConfig = lib.concatStringsSep "\n" alloyConfig;

  configFile = pkgs.writeText "alloy_config" alloyConfig;

  inherit (lib) mkEnableOption mkIf mkOption;
in
{
  options.looniversity.monitoring.alloy = {
    enable = mkEnableOption "alloy";
    livedebug = mkOption {
      type = types.bool;
      default = false;
      decription = "Enable live debugging";
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
