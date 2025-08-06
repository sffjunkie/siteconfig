{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.tui.bagels;
  inherit (lib)
    enabled
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.tui.bagels = {
    enable = mkEnableOption "bagels";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.bagels
    ];
  };
}
