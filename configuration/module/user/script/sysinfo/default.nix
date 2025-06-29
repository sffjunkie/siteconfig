{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.sysinfo;
  inherit (lib) mkDefault mkEnableOption mkIf;

  sysinfo = pkgs.writeScriptBin "sysinfo" ''
    #!${pkgs.runtimeShell}
    width=$(tput cols)
    ${pkgs.figlet}/bin/figlet -w ''${width} "System Information"
    ${pkgs.fastfetch}/bin/fastfetch
  '';
in
{
  options.looniversity.script.sysinfo = {
    enable = mkEnableOption "sysinfo";
  };

  config = mkIf cfg.enable {
    home.packages = [ sysinfo ];
  };
}
