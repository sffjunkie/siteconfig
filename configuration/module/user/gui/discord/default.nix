{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.discord;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.discord = {
    enable = mkEnableOption "discord";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.discord
    ];
  };
}
