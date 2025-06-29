{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.script.paths;
  inherit (lib) mkDefault mkEnableOption mkIf;

  paths = pkgs.writeScriptBin "paths" ''
    echo $PATH | tr : '\n'
  '';
in
{
  options.looniversity.script.paths = {
    enable = mkEnableOption "paths";
  };

  config = mkIf cfg.enable {
    home.packages = [ paths ];
  };
}
