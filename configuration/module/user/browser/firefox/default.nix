{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.firefox;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.gui.firefox = {
    enable = mkEnableOption "firefox";
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = { };
      };
    };
  };
}
