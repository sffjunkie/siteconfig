{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.zathura;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.zathura = {
    enable = mkEnableOption "zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura.enable = true;
  };
}
