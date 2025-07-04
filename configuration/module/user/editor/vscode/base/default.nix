{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.vscode;
  inherit (lib) mkDefault mkEnableOption mkIf;

  vscodeExtensions = with pkgs.vscode-extensions; [
    arcticicestudio.nord-visual-studio-code
    bierner.markdown-mermaid
    editorconfig.editorconfig
    dotjoshjohnson.xml
    fill-labs.dependi
    github.vscode-github-actions
    golang.go
    gruntfuggly.todo-tree
    humao.rest-client
    mkhl.direnv
    ms-vscode.makefile-tools
    ms-vscode-remote.remote-containers
    oderwat.indent-rainbow
    pkief.material-icon-theme
    stkb.rewrap
    twxs.cmake
    zxh404.vscode-proto3

    esbenp.prettier-vscode
    dbaeumer.vscode-eslint
    github.vscode-pull-request-github
  ];

  marketplaceExtensionsList =
    with inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      dlasagno.rasi
      executablebookproject.myst-highlight
      github.remotehub
      kennylong.kubernetes-yaml-formatter
      lencerf.beancount
      ms-vscode.cpptools-extension-pack
      ramyaraoa.show-offset
      rust-lang.rust-analyzer
      shipitsmarter.sops-edit
      techer.open-in-browser
      tomphilbin.gruvbox-themes
      runem.lit-plugin
    ];
in
{
  options.looniversity.editor.vscode = {
    enable = mkEnableOption "vscode";
  };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode.fhs;

      mutableExtensionsDir = true;
      profiles = {
        default = {
          extensions = vscodeExtensions ++ marketplaceExtensionsList;

          userSettings = {
            "cSpell.enabled" = false;

            "diffEditor.ignoreTrimWhitespace" = false;

            "editor.foldingHighlight" = false;
            "editor.formatOnSave" = true;
            "editor.lineNumbers" = "relative";
            "editor.parameterHints.enabled" = false;

            "explorer.confirmDragAndDrop" = false;
            "explorer.compactFolders" = false;

            "files.insertFinalNewline" = true;
            "files.exclude" = {
              ".devenv" = true;
              ".direnv" = true;
            };

            "terminal.integrated.scrollback" = 5000;
            "terminal.integrated.fontSize" = mkIf (!config.stylix.targets.vscode.enable) 12;
            "terminal.integrated.defaultProfile.linux" = "bash";

            "update.mode" = "manual";

            "workbench.startupEditor" = "readme";

            "[jsonc]" = {
              "editor.defaultFormatter" = "vscode.json-language-features";
            };
          };
        };
      };
    };
  };
}
