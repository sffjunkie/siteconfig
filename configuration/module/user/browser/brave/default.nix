{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.brave;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.brave
    ];
  };
}
