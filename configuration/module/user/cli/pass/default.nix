{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.pass;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.pass = {
    enable = mkEnableOption "pass";
  };

  config = mkIf cfg.enable {
    programs.password-store = {
      enable = true;
    };
  };
}
