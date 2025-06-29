{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.autoUpgrade;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.service.autoUpgrade = {
    enable = mkEnableOption "autoUpgrade";
  };

  config = mkIf cfg.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      allowReboot = true;
      rebootWindow = {
        lower = "01:00";
        upper = "03:00";
      };
      flake = "github:sffjunkie/nixos";
    };
  };
}
