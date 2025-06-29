{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.just;
  inherit (lib) mkDefault mkEnableOption mkIf;

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      skellock.just
    ];
in
{
  options.looniversity.editor.vscode.just = {
    enable = mkEnableOption "vscode just configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = marketplaceExtensionsList;

          userSettings = {
            "files.associations" = {
              "*.just" = "just";
            };
          };
        };
      };
    };
  };
}
