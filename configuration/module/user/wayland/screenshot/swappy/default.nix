{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.screenshot.swappy;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.wayland.screenshot.swappy.enable = mkEnableOption "swappy";

  config = mkIf cfg.enable {
    xdg.configFile."swappy/config".text = ''
      [Default]
      save_dir=$XDG_PICTURES_DIR/Screenshots
      save_filename_format=swappy-%Y%m%d-%H%M%S.png
    '';
  };
}
