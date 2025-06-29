{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.theme.nord;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.theme.nord = {
    enable = mkEnableOption "nord theme";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nordic
      (pkgs.hiPrio pkgs.papirus-nord)
    ];
  };
}
