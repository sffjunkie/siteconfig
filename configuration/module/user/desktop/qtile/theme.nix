{
  config,
  lib,
  pkgs,
  ...
}:
let
  defaultFontSize = 12;
  defaultTextFont = {
    family = "Hack Nerd Font Mono";
    size = defaultFontSize;
  };

  defaultIconFont = {
    family = "Hack Nerd Font Mono";
    size = defaultFontSize;
  };

  defaultWeatherFont = {
    family = "Hack Nerd Font Mono";
    size = defaultFontSize;
  };

  defaultLogoFont = {
    family = "Hack Nerd Font Mono";
    size = defaultFontSize;
  };

  defaultMargin = 4;

  defaultBase16Colors = {
    base00 = "#f9f5d7";
    base01 = "#ebdbb2";
    base02 = "#d5c4a1";
    base03 = "#bdae93";
    base04 = "#665c54";
    base05 = "#504945";
    base06 = "#3c3836";
    base07 = "#282828";
    base08 = "#9d0006";
    base09 = "#af3a03";
    base0A = "#b57614";
    base0B = "#79740e";
    base0C = "#427b58";
    base0D = "#076678";
    base0E = "#8f3f71";
    base0F = "#d65d0e";
  };

  defaultBase16 = {
    scheme_name = null;
    scheme_dir = null;
    palette = defaultBase16Colors;
  };

  defaultNamedColors = {
    panel_fg = defaultBase16Colors.base04;
    panel_bg = defaultBase16Colors.base01;

    group_current_fg = defaultBase16Colors.base05;
    group_current_bg = defaultBase16Colors.base03;
    group_active_fg = defaultBase16Colors.base07;
    group_active_bg = defaultBase16Colors.base04;
    group_inactive_fg = defaultBase16Colors.base07;
    group_inactive_bg = defaultBase16Colors.base04;

    widget_bg = [ defaultBase16Colors.base0F ];
    widget_fg_dark = defaultBase16Colors.base00;
    widget_fg_light = defaultBase16Colors.base04;

    window_border = defaultBase16Colors.base06;

  };
in
{
  config = {
    xdg.configFile."desktop/default_theme.yaml".text = lib.generators.toYAML { } {
      bar = {
        top = {
          height = 22;
          margin = [
            defaultMargin
            defaultMargin
            0
            defaultMargin
          ];
          opacity = 1.0;
        };

        bottom = {
          height = 22;
          margin = [
            0
            defaultMargin
            defaultMargin
            defaultMargin
          ];
          opacity = 1.0;
        };
      };

      color = {
        base16 = defaultBase16;
        named = defaultNamedColors;
      };

      extension = {
        font = defaultTextFont.family;
        fontsize = defaultTextFont.size;
        foreground = defaultBase16Colors.base04;
        background = defaultBase16Colors.base00;
      };

      font = {
        text = defaultTextFont;
        icon = defaultIconFont;
        weather = defaultWeatherFont;
        logo = defaultLogoFont;
      };

      layout = {
        margin = defaultMargin;
        border_width = 3;
        border_focus = defaultBase16Colors.base02;
        border_normal = defaultBase16Colors.base07;
      };

      logo = ""; # Nixos logo

      widget = {
        font = defaultTextFont.family;
        fontsize = defaultTextFont.size;
        margin = 0;
        padding = 0;
        foreground = defaultBase16Colors.base00;
        background = defaultBase16Colors.base07;
      };
    };
  };
}
