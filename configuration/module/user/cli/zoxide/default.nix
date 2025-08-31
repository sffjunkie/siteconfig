{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.cli.zoxide;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.cli.zoxide = {
    enable = mkEnableOption "zoxide";
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      # settings = {
      #   show_startup_tips = false;
      #   keybinds = {
      #     unbind = [ "Ctrl q" ];
      #   };
      # };
    };
  };
}
