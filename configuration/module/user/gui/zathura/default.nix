{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.zathura;
  inherit (lib)
    enabled
    mkDefault
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.gui.zathura = {
    enable = mkEnableOption "zathura";
  };

  config = mkIf cfg.enable {
    programs.zathura = enabled;
  };
}
