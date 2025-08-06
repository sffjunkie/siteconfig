{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.ai;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.editor.vscode.ai = {
    enable = mkEnableOption "vscode ai configuration";
    default = false;
  };

  config = mkIf (!cfg.enable) {
    programs.vscode = {
      profiles = {
        default = {
          userSettings = {
            "dataWrangler.experiments.copilot.enabled" = false;
            "chat.agent.enabled" = false;
            "chat.extensionTools.enabled" = false;
            "chat.focusWindowOnConfirmation" = false;
            "chat.setupFromDialog" = false;
            "remote.SSH.experimental.chat" = false;
            "chat.commandCenter.enabled" = false;
            "gitlab.duoChat.enabled" = false;
            "workbench.editor.empty.hint" = "hidden";
          };
        };
      };
    };
  };
}
