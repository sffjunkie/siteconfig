{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.gui;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.role.gui = {
    enable = mkEnableOption "gui role";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
    };

    looniversity = {
      desktop = {
        environment = {
          gnome.enable = false;
          qtile.enable = true;
        };
      };
    };
  };
}
