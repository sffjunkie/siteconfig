{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.htmldoc;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.htmldoc = {
    enable = mkEnableOption "htmldoc";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.htmldoc
    ];
  };
}
