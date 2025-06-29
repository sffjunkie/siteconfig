{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.virtualisation.vagrant;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.virtualisation.vagrant = {
    enable = mkEnableOption "vagrant";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.vagrant
    ];
  };
}
