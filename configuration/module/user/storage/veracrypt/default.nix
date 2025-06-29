{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.storage.veracrypt;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.storage.veracrypt = {
    enable = mkEnableOption "veracrypt";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.veracrypt
    ];
  };
}
