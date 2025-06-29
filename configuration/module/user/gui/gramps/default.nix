{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.gramps;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.gramps = {
    enable = mkEnableOption "gramps";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gramps
    ];
  };
}
