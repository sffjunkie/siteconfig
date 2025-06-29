{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.fd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.fd = {
    enable = mkEnableOption "fd";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.fd
    ];
  };
}
