{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.just;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.just = {
    enable = mkEnableOption "just";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.just
    ];
  };
}
