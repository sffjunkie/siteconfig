{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.htop;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.htop = {
    enable = mkEnableOption "htop";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.htop
    ];
  };
}
