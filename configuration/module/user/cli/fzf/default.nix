{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.fzf;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.cli.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      colors = mkIf (!config.stylix.targets.fzf.enable) {
        fg = "#D8DEE9";
        bg = "#2E3440";
        hl = "#A3BE8C";
        "fg+" = "#D8DEE9";
        "bg+" = "#434C5E";
        "hl+" = "#A3BE8C";
        pointer = "#BF616A";
        info = "#4C566A";
        spinner = "#4C566A";
        header = "#4C566A";
        prompt = "#81A1C1";
        marker = "#EBCB8B";
      };
    };
  };
}
