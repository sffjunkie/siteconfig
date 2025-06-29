{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.jc;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.jc = {
    enable = mkEnableOption "jc";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.jc
    ];
  };
}
