{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.darktable;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.darktable = {
    enable = mkEnableOption "darktable";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.darktable
    ];
  };
}
