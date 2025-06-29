{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.clipboard.wl-clipboard;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    ;
in
{
  options.looniversity.wayland.clipboard.wl-clipboard = {
    enable = mkEnableOption "wl-clipboard";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wl-clipboard
    ];
  };
}
