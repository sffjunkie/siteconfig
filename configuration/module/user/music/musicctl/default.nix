{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.looniversity.music.musicctl;
  notify_send = "${pkgs.libnotify}/bin/notify-send";
  mpc = "${pkgs.mpc-cli}/bin/mpc";
  playerctl = "${pkgs.playerctl}/bin/playerctl -p mpd";

  musicctl = pkgs.writeScriptBin "musicctl" ''
    #!${pkgs.runtimeShell}
    case "$1" in
      next)
        ${playerctl} next
        ;;
      previous)
        ${playerctl} previous
        ;;
      toggle)
        ${playerctl} play-pause
        ${notify_send} --hint=int:transient:1 -t 2000 "MPD" "$(${mpc} current)\\n$(${mpc} | sed -n 2p)"
        ;;
      stop)
        ${playerctl} stop
        ${notify_send} --hint=int:transient:1 -t 2000 "MPD" "stopped"
        ;;
      mixer)
          ${pkgs.pulsemixer}/bin/pulsemixer
          ;;
      *)
          ${playerctl} metadata
          ;;
    esac

    exit 0
  '';
in
{
  options.looniversity.music.musicctl = {
    enable = mkEnableOption "musicctl";
  };

  config = mkIf cfg.enable {
    home.packages = [ musicctl ];
  };
}
