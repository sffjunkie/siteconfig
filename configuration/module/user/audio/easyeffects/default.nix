{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.audio.easyeffects;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.audio.easyeffects = {
    enable = mkEnableOption "easyeffects";
  };

  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
    };
  };
}
