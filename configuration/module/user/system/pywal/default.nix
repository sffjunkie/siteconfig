{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.pywal;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.system.pywal = {
    enable = mkEnableOption "pywal";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.pywal
    ];
  };
}
