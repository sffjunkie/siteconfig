{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.desktop.environment.qtile;

  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.desktop.environment.qtile = {
    enable = mkEnableOption "qtile desktop";
  };

  config = mkIf cfg.enable {
    sops.secrets."sdk/location/latitude" = {
      sopsFile = config.sopsFiles.user;
    };

    sops.secrets."sdk/location/longitude" = {
      sopsFile = config.sopsFiles.user;
    };

    sops.secrets."sdk/api_key/owm" = {
      sopsFile = config.sopsFiles.user;
    };

    sops.templates."sdk_location" = {
      content = ''
        USER_LOCATION_LATITUDE=${config.sops.placeholder."sdk/location/latitude"}
        USER_LOCATION_LONGITUDE=${config.sops.placeholder."sdk/location/longitude"}
        OWM_API_KEY=${config.sops.placeholder."sdk/api_key/owm"}
      '';
      owner = config.users.users.sdk.name;
    };

    environment.shellAliases = {
      qtile_reload = "qtile cmd-obj -o cmd -f reload_config";
    };

    environment.systemPackages = [
      pkgs.gsettings-desktop-schemas
    ];

    looniversity = {
      desktop = {
        display_manager.greetd = {
          enable = true;
        };
        greeter.tuigreet = {
          enable = true;
        };
        window_manager.qtile = {
          enable = true;
          extraEnvVars = [
            "TERMINAL"
            "BROWSER"
          ];
          extraPythonPackages = (
            ps: [
              # Extra widgets
              ps.qtile-extras

              # Packages required by widgets
              ps.dbus-fast # Bluetooth
              ps.psutil # CPU
              ps.pulsectl-asyncio # PulseVolume

              # Packages required by config
              ps.pyyaml
            ]
          );
          environmentFile = config.sops.templates."sdk_location".path;
        };
      };

      wayland = {
        lockscreen.swaylock = enabled;
      };
    };

    programs = {
      dconf = enabled;
      xwayland = enabled;
    };

    security.polkit = enabled;

    xdg.portal = {
      enable = true;
      configPackages = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
      wlr = enabled;
    };
  };
}
