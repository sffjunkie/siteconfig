{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.media.droidcam;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.media.droidcam = {
    enable = mkEnableOption "droidcam";
  };

  config = mkIf cfg.enable {
    programs.droidcam = {
      enable = true;
    };
  };
}
