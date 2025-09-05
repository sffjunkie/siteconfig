{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.monitoring.prometheus;
  port = lib.network.serviceHandlerMainPort config "prometheus";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.prometheus = {
    enable = mkEnableOption "prometheus";
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = port;

      scrapeConfigs = [
        {
          job_name = "prometheus";
          scrape_interval = "5s";
          static_configs = [
            {
              targets = [ "localhost:${toString port}" ];
            }
          ];
        }
      ];
    };

    networking.firewall.allowedTCPPorts = [ port ];
  };
}
