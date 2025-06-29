{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.yubikeyManager;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.yubikeyManager = {
    enable = mkEnableOption "Yubikey Manager";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.yubikey-manager
    ];
  };
}
