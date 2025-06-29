{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.micro;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.editor.micro = {
    enable = mkEnableOption "micro";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.micro
    ];
    xdg.configFile."micro/bindings.json" = {
      force = true;
      text = ''
        {
          "Alt-CtrlQ": "ForceQuit"
        }
      '';
    };

    home.sessionVariables = {
      EDITOR = "micro";
    };
  };
}
