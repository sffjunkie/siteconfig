{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.shellcheck;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.development.shellcheck = {
    enable = mkEnableOption "shellcheck";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.shellcheck
    ];
  };
}
