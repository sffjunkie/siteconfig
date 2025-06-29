{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.audio.qpwgraph;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.audio.qpwgraph = {
    enable = mkEnableOption "qpwgraph";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.qpwgraph
    ];
  };
}
