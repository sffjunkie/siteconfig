{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.service.syncthing;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.service.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing.enable = true;
  };
}
