{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.syncthing;
  inherit (lib)
    enabled
    mkDefault
    mkEnableOption
    mkIf
    ;
in
{
  options.looniversity.service.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = enabled;
  };
}
