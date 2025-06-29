{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.vscode;
  inherit (lib) mkIf mkForce;
in
{
  config = mkIf cfg.enable {
    programs.vscode = {
      userSettings = {
        "window.zoomLevel" = mkForce 0;
      };
    };
  };
}
