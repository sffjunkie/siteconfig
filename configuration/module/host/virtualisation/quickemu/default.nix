{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.virtualisation.quickemu;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.virtualisation.quickemu = {
    enable = mkEnableOption "quickemu";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.quickemu
    ];
  };
}
