{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.lazydocker;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.lazydocker = {
    enable = mkEnableOption "lazydocker";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.lazydocker
    ];
  };
}
