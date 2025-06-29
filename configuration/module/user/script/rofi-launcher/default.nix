{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.rofi-launcher;

  rofi-launcher-script = pkgs.writeScriptBin "rofi-launcher" ''
    #!${lib.getExe pkgs.bash}
    ${lib.getExe pkgs.rofi} \
      -theme-str '@import "looniversity"' \
      -modi drun \
      -show drun
  '';
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.script.rofi-launcher = {
    enable = mkEnableOption "rofi-launcher script";
  };

  config = mkIf cfg.enable {
    home.packages = [
      rofi-launcher-script
    ];
  };
}
