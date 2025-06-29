{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.git;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "Simon Kennedy";
      userEmail = "sffjunkie+code@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        http.postBuffer = "157286400";
      };
    };

    programs.zsh.shellAliases = mkIf config.looniversity.shell.zsh.enable {
      gvl = "git config --list --show-origin";
    };
  };
}
