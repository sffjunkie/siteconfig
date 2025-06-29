{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.lutris;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.game.lutris = {
    enable = mkEnableOption "lutris";
  };

  config = mkIf cfg.enable {
    hardware.graphics.enable32Bit = true;
    environment.systemPackages = [
      pkgs.lutris
    ];
  };
}
