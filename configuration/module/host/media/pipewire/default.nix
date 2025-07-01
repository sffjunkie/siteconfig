{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.media.pipewire;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.media.pipewire = {
    enable = mkEnableOption "pipewire";
  };

  config = mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit = enabled;
    services.pipewire = {
      enable = true;
      alsa = enabled // {
        support32Bit = true;
      };
      jack = enabled;
      pulse = enabled;
    };
  };
}
