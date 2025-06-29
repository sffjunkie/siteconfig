{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.storage.udiskie;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.storage.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.looniversity.storage.udisks2.enable;
        message = "Required machine service 'udisks2' is not enabled";
      }
    ];

    services.udiskie = {
      enable = true;
      tray = "never";
    };
  };
}
