{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.keyring;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.keyring = {
    enable = mkEnableOption "keyring";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
  };
}
