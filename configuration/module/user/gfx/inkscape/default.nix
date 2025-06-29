{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.inkscape;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.inkscape = {
    enable = mkEnableOption "inkscape";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.inkscape
    ];
  };
}
