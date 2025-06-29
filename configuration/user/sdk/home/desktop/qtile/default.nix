{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
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
        fuzzel.enable = true;
      };

      script = {
        system-menu.enable = true;
        rofi-clip.enable = true;
        rofi-launcher.enable = true;
      };
    };
  };
}
