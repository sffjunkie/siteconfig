{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.lsd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.lsd = {
    enable = mkEnableOption "lsd";
  };

  config = mkIf cfg.enable {
    programs.lsd = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
