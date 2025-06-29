{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode;
  inherit (lib) mkDefault mkIf;
in
{
  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          userSettings = {
            "editor.fontFamily" = mkIf (
              !config.stylix.targets.vscode.enable
            ) "'JetBrainsMono Nerd Font', 'DejaVu Sans Mono', monospace";

            "editor.fontSize" = mkIf (!config.stylix.targets.vscode.enable) 12;

            "editor.rulers" = [
              80
              100
            ];

            "window.titleBarStyle" = "custom";
            "window.zoomLevel" = mkDefault 2;

            "workbench.panel.defaultLocation" = "right";
            "workbench.startupEditor" = "readme";
          };
        };
      };
    };
  };
}
