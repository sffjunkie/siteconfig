{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.clipboard.cliphist;
  inherit (lib)
    enabled
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
    services.cliphist = enabled;
    looniversity.wayland.clipboard.wl-clipboard = enabled;
  };
}
