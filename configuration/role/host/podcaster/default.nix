{
  config,
  lib,
  ...
}:
let
  cfg = config.looniversity.role.podcaster;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.role.podcaster = {
    enable = mkEnableOption "podcaster role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      media.droidcam = {
        enable = true;
      };
    };
  };
}
