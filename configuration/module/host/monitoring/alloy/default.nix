{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.monitoring.alloy;
  port = lib.network.serviceHandlerMainPort config "alloy";
  lokiPort = lib.network.serviceHandlerMainPort config "loki";
  lokiHost = lib.network.serviceHandlerHost config "loki";

  configJournald = ''
    loki.source.journal "local" {
      forward_to = [loki.write.looniversity.receiver]
    }
  '';

  configWrite = ''
    loki.write "looniversity" {
        endpoint {
            url = "http://${lokiHost}:${toString lokiPort}/loki/api/v1/push"
        }
    }
  '';

  config = configJournald + configWrite;

  configFile = pkgs.writeText "alloy_config" config;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.alloy = {
    enable = mkEnableOption "alloy";
  };

  config = mkIf cfg.enable {
    services.alloy = {
      enable = true;
      configPath = "${toString configFile}";
    };
    networking.firewall.allowedTCPPorts = [ port ];
  };
}
