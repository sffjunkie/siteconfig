{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.nix;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    jnoortheen.nix-ide
    brettm12345.nixfmt-vscode
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
    ];
in
{
  options.looniversity.editor.vscode.nix = {
    enable = mkEnableOption "vscode nix configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "[nix]" = {
              "editor.tabSize" = 2;
              "editor.defaultFormatter" = "brettm12345.nixfmt-vscode";
            };
          };
        };
      };
    };
  };
}
