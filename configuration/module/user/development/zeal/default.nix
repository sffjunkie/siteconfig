{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.zeal;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.zeal = {
    enable = mkEnableOption "zeal";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.zeal
    ];
  };
}
