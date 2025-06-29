{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.lazygit;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.lazygit = {
    enable = mkEnableOption "lazygit";
  };

  config = mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
    };

    programs.zsh.shellAliases = {
      lg = "lazygit";
    };
  };
}
