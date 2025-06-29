{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.gittyup;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.gittyup = {
    enable = mkEnableOption "gittyup";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gittyup
    ];
  };
}
