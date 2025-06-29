# https://github.com/terrortylor/nvim-comment/
{ pkgs, ... }:
{
  config = {
    programs.nixvim = {
      extraPlugins = [
        pkgs.vimPlugins.nvim-comment
      ];

      extraConfigLua = ''
        require('nvim_comment').setup()
      '';
    };
  };
}
