{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.pulsemixer;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.pulsemixer = {
    enable = mkEnableOption "pulsemixer";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.pulsemixer
    ];
  };
}
