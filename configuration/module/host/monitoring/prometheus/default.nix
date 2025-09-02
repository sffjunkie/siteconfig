# ports: 27017 - 27020
{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.monitoring.prometheus;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.monitoring.prometheus = {
    enable = mkEnableOption "prometheus";
  };

  config = mkIf cfg.enable {
    services.prometheus = {
      enable = true;
      port = 9001;
    };
  };
}
