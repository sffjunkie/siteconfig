{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.media.pavucontrol;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.media.pavucontrol = {
    enable = mkEnableOption "pavucontrol";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.pavucontrol
    ];
  };
}
