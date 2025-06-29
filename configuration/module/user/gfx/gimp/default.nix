{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.gimp;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.gimp = {
    enable = mkEnableOption "gimp";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gimp
    ];
  };
}
