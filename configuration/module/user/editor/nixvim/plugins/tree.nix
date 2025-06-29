# https://github.com/nvim-tree/nvim-tree.lua
{
  config = {
    programs.nixvim = {
      plugins.nvim-tree = {
        enable = true;
      };
    };
  };
}
