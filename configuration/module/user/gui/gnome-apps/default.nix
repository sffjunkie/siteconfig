{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.gnomeApps;
  inherit (lib) mkEnableOption mkIf;
  inherit (pkgs) gnome;
in
{
  options.looniversity.gui.gnomeApps = {
    enable = mkEnableOption "gnomeApps";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gnome-boxes
      pkgs.gnome-characters
      pkgs.adwaita-icon-theme
      pkgs.dconf-editor
      pkgs.ghex
      pkgs.gnome-calculator
      pkgs.gnome-tweaks
    ];
  };
}
