{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.bat;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.bat = {
    enable = mkEnableOption "bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
      ];
    };

    programs.zsh.shellAliases = {
      man = "batman";
    };

    home.sessionVariables = {
      PAGER = "bat";
    };
  };
}
