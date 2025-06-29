{
  config,
  lib,
  pkgs,
  mopidy-iris,
  mopidy-jellyfin,
  mopidy-local,
  mopidy-mpd,
  mopidy-spotify,
  ...
}:
let
  cfg = config.looniversity.media.mopidy;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.media.mopidy = {
    enable = mkEnableOption "mopidy";
  };

  config = mkIf cfg.enable {
    services.mopidy = {
      enable = true;
      extensionPackages = [
        mopidy-iris
        mopidy-jellyfin
        mopidy-local
        mopidy-mpd
        mopidy-spotify
      ];

      configuration = ''
        [iris]
        country = uk
        locale = en_GB
      '';
    };
  };
}
