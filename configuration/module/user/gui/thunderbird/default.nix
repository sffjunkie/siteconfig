{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.thunderbird;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.thunderbird = {
    enable = mkEnableOption "thunderbird";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.thunderbird
    ];
  };
}
