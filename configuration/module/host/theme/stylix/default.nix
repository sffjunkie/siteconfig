{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.theme.stylix;

  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.theme.stylix = {
    enable = mkEnableOption "stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      image = ./dark_swirl.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";

      cursor = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
        size = 32;
      };

      fonts = {
        monospace = {
          name = "JetBrainsMono Nerd Font";
          package = pkgs.nerd-fonts.jetbrains-mono;
        };

        sizes = {
          applications = 13;
          popups = 13;
          terminal = 13;
        };
      };

      polarity = "dark";
    };
  };
}
