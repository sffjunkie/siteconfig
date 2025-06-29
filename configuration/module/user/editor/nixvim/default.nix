{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.editor.nixvim;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.editor.nixvim = {
    enable = mkEnableOption "nixvim";
  };

  imports = [
    ./autocmd.nix
    ./keymap
    ./lua-pre.nix
    ./globals.nix
    ./options.nix
    ./plugins
  ];

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      extraPackages = [
        pkgs.vimPlugins.nvim-web-devicons
      ];
    };
  };
}
