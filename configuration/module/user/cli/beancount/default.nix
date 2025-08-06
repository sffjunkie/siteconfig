{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.beancount;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.beancount = {
    enable = mkEnableOption "beancount";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.beancount
      pkgs.beanquery
      pkgs.fava
    ];
  };
}
