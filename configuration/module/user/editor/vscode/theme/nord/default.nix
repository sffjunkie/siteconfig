{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.theme.nord;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    arcticicestudio.nord-visual-studio-code
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    ];
in
{
  options.looniversity.editor.vscode.theme.nord = {
    enable = mkEnableOption "vscode nord theme";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "editor.tokenColorCustomizations" = {
              "[Nord]" = {
                "comments" = "#94b9a6";
              };
            };
            "workbench.colorTheme" = mkIf (!config.stylix.targets.vscode.enable) "Nord";
          };
        };
      };
    };
  };
}
