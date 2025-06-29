{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.system-menu;

  rofi = config.programs.rofi.package;

  system-menu-script = pkgs.writeScriptBin "system-menu" ''
    #!${lib.getExe pkgs.bash}
    swapon --show | grep "dev" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      hibernate_choice="/hibernate"
    else
      hibernate_choice=""
    fi

    choices="suspend/lockscreen''${hibernate_choice}/reboot/shutdown"
    ${lib.getExe rofi} \
      -theme-str '@import "looniversity"' \
      -show power-menu \
      -modi "power-menu:rofi-power-menu --choices=''${choices}"
  '';
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.script.system-menu = {
    enable = mkEnableOption "system-menu script";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.rofi-power-menu
      system-menu-script
    ];
  };
}
