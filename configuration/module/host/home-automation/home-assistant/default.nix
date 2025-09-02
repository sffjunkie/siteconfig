{
  config,
  lib,
  sops,
  ...
}:
let
  cfg = config.looniversity.home-automation.home-assistant;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.home-automation.home-assistant = {
    enable = mkEnableOption "home-assistant";
  };

  config = mkIf cfg.enable {
    sops.secrets."hass/latitude" = {
      owner = config.users.users.hass.name;
      sopsFile = config.sopsFiles.home-automation;
    };

    sops.secrets."hass/longitude" = {
      owner = config.users.users.hass.name;
      sopsFile = config.sopsFiles.home-automation;
    };

    sops.secrets."hass/elevation" = {
      owner = config.users.users.hass.name;
      sopsFile = config.sopsFiles.home-automation;
    };

    sops.templates."secret.yaml" = {
      content = ''
        latitude: ${config.sops.placeholder."hass/latitude"}
        longitude: ${config.sops.placeholder."hass/longitude"}
        elevation: ${config.sops.placeholder."hass/elevation"}
      '';
    };

    services.home-assistant = {
      enable = true;

      config = {
        default_config = { };
        ios = { };
        automation = "!include automations.yaml";
        sensor = "!include sensors.yaml";
        scene = "!include scenes.yaml";
        script = "!include scripts.yaml";

        homeassistant = {
          name = "Home";
          latitude = "!secret latitude";
          longitude = "!secret longitude";
          elevation = "!secret elevation";
          temperature_unit = "C";
          unit_system = "metric";
          time_zone = "UTC";
        };

        http = {
          server_host = "0.0.0.0";
          server_port = 8123;
          use_x_forwarded_for = true;
          trusted_proxies = "10.44.0.0/21";
        };

        influxdb = {
          ssl = false;
          verify_ssl = false;
          exclude = {
            domains = [
              "automation"
              "group"
            ];
          };
        };

        recorder = {
          db_url = "!secret postgres_connection";
          exclude = {
            entities = [
              "sun.sun"
              "sensor.new_delhi"
              "sensor.new_york"
              "sensor.san_francisco"
              "sensor.time"
              "sensor.date"
            ];
          };
        };

        frontend = {
          themes = "!include_dir_merge_named themes";
        };
      };
    };
  };
}
