{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.mpv;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.mpv = {
    enable = mkEnableOption "mpv";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.mpv
      pkgs.mpvScripts.mpris
    ];
  };
}
