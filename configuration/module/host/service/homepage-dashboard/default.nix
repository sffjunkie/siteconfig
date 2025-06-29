{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.homepage-dashboard;

  dashboardPort = lib.network.serviceHandlerMainPort config "homepage-dashboard";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.homepage-dashboard = {
    enable = mkEnableOption "homepage-dashboard";
  };

  config = mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      listenPort = dashboardPort;
    };
  };
}
