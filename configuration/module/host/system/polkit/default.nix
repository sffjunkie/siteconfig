{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.looniversity.system.polkit;
in
{
  options.looniversity.system.polkit = {
    enable = mkEnableOption "polkit";
  };

  config = mkIf cfg.enable {
    security.polkit = {
      enable = true;
    };
  };
}
