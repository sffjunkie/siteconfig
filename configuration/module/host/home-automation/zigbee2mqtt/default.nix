{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.home-automation.zigbee2mqtt;

  format = pkgs.formats.yaml { };
  configFile = format.generate "zigbee2mqtt.yaml" cfg.settings;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.home-automation.zigbee2mqtt = {
    enable = mkEnableOption "zigbee2mqtt";

    devices = mkOption {
      type = format.type;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."zigbee2mqtt/mqtt_password" = {
      owner = config.users.users.zigbee2mqtt.name;
      sopsFile = config.sopsFiles.service;
    };

    sops.secrets."zigbee2mqtt/network_key" = {
      owner = config.users.users.zigbee2mqtt.name;
      sopsFile = config.sopsFiles.service;
    };

    sops.templates."secret.yaml" = {
      content = ''
        network_key: ${config.sops.placeholder."zigbee2mqtt/network_key"}
      '';
    };

    services.zigbee2mqtt = {
      enable = true;
      passwordFile = config.sops.secrets."zigbee2mqtt/mqtt_password".path;

      settings = {
        permit_join = true;
        mqtt = {
          # TODO: Use lib functions
          server = "mqtt://thebrain.looniversity.net:1883";
          base_topic = "zigbee2mqtt";
          user = "zigbee2mqtt";
        };
        serial = {
          port = "/dev/ttyUSB0";
          adapter = "zstack";
        };
        frontend = {
          enabled = true;
          port = 8080;
        };
        home_assistant = {
          enabled = true;
        };
        advanced = {
          homeassistant_legacy_entity_attributes = false;
          legacy_api = false;
          legacy_availability_payload = false;
          log_level = "info";
        };
        device_options = {
          legacy = false;
        };
      };
    };
  };
}
