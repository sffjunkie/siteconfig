{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.fuzzel;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.fuzzel = {
    enable = mkEnableOption "fuzzel";
  };

  config = mkIf cfg.enable {
    programs.fuzzel = {
      enable = true;
    };
  };
}
