{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.wayland.display.wlr-randr;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.wayland.display.wlr-randr = {
    enable = mkEnableOption "wlr-randr display management";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.wlr-randr
    ];
  };
}
