{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.influxdb;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.influxdb = {
    enable = mkEnableOption "influxdb";
  };

  config = mkIf cfg.enable {
    services.influxdb = {
      enable = true;
    };
  };
}
