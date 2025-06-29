# ports: 27017 - 27020
{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.service.mongodb;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.mongodb = {
    enable = mkEnableOption "mongodb";
  };

  config = mkIf cfg.enable {
    services.mongodb = {
      enable = true;
      # bind_ip = "0.0.0.0";
    };
  };
}
