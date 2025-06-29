{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.keepassxc;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.keepassxc = {
    enable = mkEnableOption "keepassxc";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.keepassxc
    ];
  };
}
