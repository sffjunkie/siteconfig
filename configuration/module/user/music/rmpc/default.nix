{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.music.rmpc;
  mpdcfg = config.looniversity.music.mpd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.music.rmpc = {
    enable = mkEnableOption "rmpc";
  };

  config = mkIf cfg.enable {
    programs.rmpc = {
      enable = true;
      config = ''
        #![enable(implicit_some)]
        #![enable(unwrap_newtypes)]
        #![enable(unwrap_variant_newtypes)]
        (
          address: "${mpdcfg.host}:${toString mpdcfg.port}",
        )
      '';
    };

    home.packages = [
      pkgs.ffmpeg
    ]
    ++ lib.optionals (config.programs.alacritty.enable) [
      pkgs.ueberzugpp
    ];
  };
}
