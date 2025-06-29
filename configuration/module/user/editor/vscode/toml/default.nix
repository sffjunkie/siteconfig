{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.toml;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    tamasfe.even-better-toml
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    ];
in
{
  options.looniversity.editor.vscode.toml = {
    enable = mkEnableOption "vscode toml configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "evenBetterToml.formatter.arrayTrailingComma" = true;
            "evenBetterToml.formatter.arrayAutoExpand" = true;
          };
        };
      };
    };
  };
}
