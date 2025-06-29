{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.imagemagick;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.imagemagick = {
    enable = mkEnableOption "imagemagick";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.imagemagick
    ];
  };
}
