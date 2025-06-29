{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.shell.zsh;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.shell.zsh = {
    enable = mkEnableOption "zsh shell";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      loginShellInit = ''
        # do not glob # as it conflicts with nix flakes
        disable -p '#'
      '';
    };
  };
}
