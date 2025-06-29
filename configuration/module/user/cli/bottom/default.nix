{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.bottom;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.bottom = {
    enable = mkEnableOption "bottom";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.bottom
    ];
  };
}
