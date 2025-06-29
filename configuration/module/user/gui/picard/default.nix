{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.picard;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.picard = {
    enable = mkEnableOption "picard";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.picard
    ];
  };
}
