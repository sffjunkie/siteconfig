{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.jq;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.jq = {
    enable = mkEnableOption "jq";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.jq
    ];
  };
}
