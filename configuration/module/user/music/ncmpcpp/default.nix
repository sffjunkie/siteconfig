{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.music.ncmpcpp;
  mpdcfg = config.looniversity.music.mpd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.music.ncmpcpp = {
    enable = mkEnableOption "ncmpcpp";
  };

  config = mkIf cfg.enable {
    programs.ncmpcpp = {
      enable = true;
      settings = {
        mpd_host = mpdcfg.host;
        mpd_port = "${toString mpdcfg.port}";

        startup_screen = "playlist";

        message_delay_time = "1";

        song_list_format = "{$4%a - }{%t}|{$8%f$9}$R{$3(%l)$9}";
        song_status_format = "{$8%t} $3by {$4%a{ $2in $7%b $8(Track %N)}}|{$8%f}";
        song_library_format = "{%n - }{%t}|{%f}";
        song_columns_list_format = "(25)[white]{t|f:Title} (37)[green]{a} (37)[cyan]{b} (6f)[white]{NE} (7f)[magenta]{l}";

        alternative_header_first_line_format = "$b$1$aqqu$/a$9 {%t}|{%f} $1$atqq$/a$9$/b";
        alternative_header_second_line_format = "{{$4$b%a$/b$9}{ - $7%b$9}{ ($4%y$9)}}|{%D}";

        current_item_prefix = "$(cyan)$r$b";
        current_item_suffix = "$/r$(end)$/b";
        current_item_inactive_column_prefix = "$(magenta)$r";
        current_item_inactive_column_suffix = "$/r$(end)";

        empty_tag_color = "magenta";
        main_window_color = "white";
        progressbar_color = "black:b";
        progressbar_elapsed_color = "blue:b";
        progressbar_look = "->";
        statusbar_color = "red";
        statusbar_time_color = "cyan:b";
        browser_display_mode = "columns";

        media_library_primary_tag = "album_artist";
        media_library_albums_split_by_date = "no";

        display_volume_level = "no";
        ignore_leading_the = "yes";
        external_editor = "nano";
        use_console_editor = "yes";

        playlist_display_mode = "columns";
        playlist_disable_highlight_delay = 0;
      };
    };
  };
}
