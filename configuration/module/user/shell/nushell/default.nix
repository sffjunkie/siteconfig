{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.shell.nushell;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.shell.nushell = {
    enable = mkEnableOption "nushell";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nushell
    ];
  };
}
