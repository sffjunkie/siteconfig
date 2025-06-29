{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.theme.papirus;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.theme.papirus = {
    enable = mkEnableOption "papirus theme";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.papirus-icon-theme
    ];
  };
}
