{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) enabled;
in
{
  config = lib.mkIf osConfig.looniversity.desktop.environment.qtile.enable {
    xdg.configFile = {
      "qtile" = {
        source = ./config;
        recursive = true;
      };
    };

    looniversity = {
      gui = {
        fuzzel = enabled;
      };

      script = {
        system-menu = enabled;
        rofi-clip = enabled;
        rofi-launcher = enabled;
      };
    };
  };
}
