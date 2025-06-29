{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.clipboard.cliphist;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    ;
in
{
  options.looniversity.wayland.clipboard.cliphist = {
    enable = mkEnableOption "cliphist";
  };

  config = mkIf cfg.enable {
    services.cliphist.enable = true;
    looniversity.wayland.clipboard.wl-clipboard.enable = true;
  };
}
