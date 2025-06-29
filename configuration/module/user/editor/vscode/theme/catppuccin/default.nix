{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.theme.catppuccin;
  inherit (lib) mkDefault mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      catppuccin.catppuccin-vsc
    ];
in
{
  options.looniversity.editor.vscode.theme.catppuccin = {
    enable = mkEnableOption "vscode catppuccin theme";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "workbench.colorTheme" = mkIf (!config.stylix.targets.vscode.enable) "Catppuccin Macchiato";
          };
        };
      };
    };
  };
}
