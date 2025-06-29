{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode.git;
  inherit (lib) mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    donjayamanne.githistory
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      charliermarsh.ruff
    ];
in
{
  options.looniversity.editor.vscode.git = {
    enable = mkEnableOption "vscode git configuration";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "git.confirmSync" = false;
            "git.openRepositoryInParentFolders" = "never";
          };
        };
      };
    };
  };
}
