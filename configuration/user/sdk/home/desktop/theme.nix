{
  config,
  lib,
  pkgs,
  ...
}:
let
  margin = 8;
  settingsFormat = pkgs.formats.yaml { };
in
{
  config = {
    xdg.configFile."desktop/theme.yaml".source = settingsFormat.generate "desktop-theme.yaml" {
      bar = {
        top = {
          height = 38;
          margin = [
            margin
            margin
            0
            margin
          ];
          opacity = 0.8;
        };
        bottom = {
          height = 38;
          margin = [
            0
            margin
            margin
            margin
          ];
          opacity = 0.8;
        };
      };

      color = {
        base16 = {
          scheme_name = "catppuccin-macchiato";
          scheme_dir = "${pkgs.base16-schemes}/share/themes";
        };

        named = {
          widget_fg_dark = "base00";
          widget_fg_light = "base04";
          widget_bg = [
            "#D08770"
          ];
        };
      };

      font = {
        text = {
          family = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
          size = 16;
        };
        ui = {
          family = "JetBrainsMono Nerd Font";
          size = 16;
        };
        icon = {
          family = "Material Design Icons";
          package = pkgs.material-design-icons;
          size = 22;
        };
        weather = {
          family = "Hack Nerd Font";
          package = pkgs.nerd-fonts.hack;
          size = 22;
        };
        logo = {
          family = "Hack Nerd Font";
          package = pkgs.nerd-fonts.hack;
          size = 22;
        };
      };

      layout = {
        margin = margin;
      };

      logo = ""; # Nixos logo
    };
  };
}
