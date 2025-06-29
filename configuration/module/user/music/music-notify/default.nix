{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.music.notify;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  ffmpeg = "${pkgs.ffmpeg}/bin/ffmpeg";
  mpc = "${pkgs.mpc-cli}/bin/mpc";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  music-notify = pkgs.writeScriptBin "music-notify" ''
    #!${pkgs.runtimeShell}
    music_dir="/mnt/music"
    filename="$(${mpc} --format "$music_dir"/%file% current)"

    previewdir="/tmp/ncmpcpp_previews"
    mkdir -p $previewdir
    previewname="$previewdir/$(${mpc} --format %album% current | base64).png"
    [ -e "$previewname" ] || ${ffmpeg} -y -i "$filename" -an -vf scale=${toString cfg.iconSize}:${toString cfg.iconSize} "$previewname" > /dev/null 2>&1

    ${notify-send} --app-name=music-notify \
      --replace-id=27072 \
      --expire-time=4000 \
      --icon="$previewname" \
      "Now Playing" "$(${mpc} --format='󰝚 %title%\n󰠃 %artist%\n󰀥 %album%' current)"
  '';
in
{
  options.looniversity.music.notify = {
    enable = mkEnableOption "music notifications";
    iconSize = mkOption {
      type = types.int;
      default = 256;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ music-notify ];

    programs.ncmpcpp.settings.execute_on_song_change = mkIf config.programs.ncmpcpp.enable "${music-notify}/bin/music-notify &";
  };
}
