{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.openmw;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.game.openmw = {
    enable = mkEnableOption "openmw";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.openmw
    ];
  };
}
