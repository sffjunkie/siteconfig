{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.game.retroarch;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.game.retroarch = {
    enable = mkEnableOption "retroarch";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.retroarch.withCores (
        cores: with cores; [
          fuse
          mame2003-plus
        ]
      ))
    ];
  };
}
