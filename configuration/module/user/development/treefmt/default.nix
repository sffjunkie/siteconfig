{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.treefmt;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.treefmt = {
    enable = mkEnableOption "treefmt";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.treefmt
    ];
  };
}
