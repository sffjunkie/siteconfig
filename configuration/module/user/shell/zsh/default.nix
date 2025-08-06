{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.shell.zsh;
  inherit (lib)
    enabled
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.shell.zsh = {
    enable = mkEnableOption "zsh";

    initContent = mkOption {
      default = "";
      type = types.lines;
      description = "Extra commands that should be added to {file}`.zshrc`.";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh";
      enableCompletion = true;
      autosuggestion = enabled;
      syntaxHighlighting = enabled;
      initContent = config.looniversity.shell.zsh.initContent;
    };

    programs.zsh.antidote = {
      enable = true;
      plugins = [
        "ptavares/zsh-direnv"
        "ohmyzsh/ohmyzsh path:lib"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-completions"
        "zsh-users/zsh-syntax-highlighting"
      ];
    };
  };
}
