{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = {
    xdg.configFile."desktop/default_settings.yaml".text = lib.generators.toYAML { } {
      app = {
        terminal = "xterm";
      };

      device = {
        net = "eth0";
      };

      key = {
        alt = "mod1";
        ctrl = "control";
        hyper = "mod3";
        shift = "shift";
        cmd = "mod4";
      };
    };
  };
}
