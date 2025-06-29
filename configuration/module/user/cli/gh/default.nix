{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.gh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.gh = {
    enable = mkEnableOption "gh";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gh
    ];
  };
}
