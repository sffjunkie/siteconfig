{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.media.pipewire;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.media.pipewire = {
    enable = mkEnableOption "pipewire";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
}
