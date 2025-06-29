{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.google-chrome;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.google-chrome = {
    enable = mkEnableOption "Google Chrome";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.google-chrome
    ];
  };
}
