{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.terminal.kitty;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.terminal.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        name = "Hack";
        size = 13;
      };
      theme = "Nord";
      extraConfig = ''
        enable_audio_bell no
      '';
    };

    home.sessionVariables = {
      TERMINAL = "kitty";
    };
  };
}
