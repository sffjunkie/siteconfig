{
  config,
  lib,
  pkgs,
  sops,
  ...
}:
let
  cfg = config.looniversity.admin.mqttx;

  mqttHost = lib.network.serviceHandlerHost config "mosquitto";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.admin.mqttx = {
    enable = mkEnableOption "mqttx";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mqttx
    ];
  };
}
