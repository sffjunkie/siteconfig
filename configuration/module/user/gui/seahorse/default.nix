{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.seahorse;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.seahorse = {
    enable = mkEnableOption "Seahorse";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.seahorse
    ];
  };
}
