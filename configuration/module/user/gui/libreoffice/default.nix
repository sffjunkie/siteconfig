{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.libreoffice;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.libreoffice = {
    enable = mkEnableOption "libreoffice";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.libreoffice
    ];
  };
}
