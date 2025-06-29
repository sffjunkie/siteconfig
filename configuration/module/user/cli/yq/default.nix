{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.yq;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.yq = {
    enable = mkEnableOption "yq";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.yq
    ];
  };
}
