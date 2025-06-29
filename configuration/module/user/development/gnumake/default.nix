{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.gnumake;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.gnumake = {
    enable = mkEnableOption "gnumake";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gnumake
    ];
  };
}
