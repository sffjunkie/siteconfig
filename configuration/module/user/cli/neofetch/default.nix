{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.neofetch;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.neofetch = {
    enable = mkEnableOption "neofetch";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.neofetch
    ];
  };
}
