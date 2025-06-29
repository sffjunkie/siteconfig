{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.fava;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.fava = {
    enable = mkEnableOption "fava";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.fava
    ];
  };
}
