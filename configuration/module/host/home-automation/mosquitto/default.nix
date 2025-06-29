{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.home-automation.mosquitto;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.home-automation.mosquitto = {
    enable = mkEnableOption "mosquitto";
  };

  config = mkIf cfg.enable {
    sops.secrets."mosquitto/password/homeassistant" = {
      owner = config.users.users.mosquitto.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."mosquitto/password/zigbee2mqtt" = {
      owner = config.users.users.mosquitto.name;
      sopsFile = config.sopsFiles.service;
    };
    sops.secrets."mosquitto/password/nodered" = {
      owner = config.users.users.mosquitto.name;
      sopsFile = config.sopsFiles.service;
    };

    services.mosquitto = {
      enable = true;

      listeners = [
        {
          port = 1883;

          users = {
            homeassistant = {
              hashedPasswordFile = config.sops.secrets."mosquitto/password/homeassistant".path;
            };
            zigbee2mqtt = {
              hashedPasswordFile = config.sops.secrets."mosquitto/password/zigbee2mqtt".path;
            };
            nodered = {
              hashedPasswordFile = config.sops.secrets."mosquitto/password/nodered".path;
            };
          };
        }
      ];
    };
  };
}
