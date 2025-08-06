{
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
}
