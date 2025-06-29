{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.settings.gnome;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.settings.gnome = {
    enable = mkEnableOption "gnome settings";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          enable-hot-corners = false;
          font-antialiasing = "rgba";
          font-hinting = "slight";
          text-scaling-factor = 1.0;
        };

        "org/gnome/desktop/peripherals/mouse" = {
          natural-scroll = true;
        };

        "org/gnome/mutter" = {
          edge-tiling = true;
        };

        "org/gnome/desktop/wm/keybindings" = {
          move-to-monitor-left = "@as []";
          move-to-monitor-right = "@as []";
          move-to-workspace-left = [ "<Shift><Super>Left" ];
          move-to-workspace-right = [ "<Shift><Super>Right" ];
          switch-input-source = "@as []";
          switch-input-source-backward = "@as []";
        };

        "org/gnome/settings-daemon/plugins/media-keys" = {
          custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = [ "<Super><Alt>space" ];
          command = "rofi --show drun --normal-window";
          name = "rofi";
        };
      };
    };
  };
}
