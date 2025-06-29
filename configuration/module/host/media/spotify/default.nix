{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.media.spotify;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.media.spotify = {
    enable = mkEnableOption "spotify";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotify
    ];
  };
}
