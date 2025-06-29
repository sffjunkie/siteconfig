{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.exiftool;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.exiftool = {
    enable = mkEnableOption "exiftool";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.exiftool
    ];
  };
}
