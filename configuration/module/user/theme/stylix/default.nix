{
  config,
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
      iconTheme = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
      };
      polarity = "dark";
    };
  };
}
