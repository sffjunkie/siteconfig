# https://github.com/nvim-tree/nvim-tree.lua
{
  config = {
    programs.nixvim = {
      plugins.auto-session = {
        enable = true;
        autoReload = {
          enable = true;
        };
        dir = ''vim.fn.expand(vim.fn.stdpath("state") .. "/persistence/sessions/")'';
      };

      keymaps = [
        {
          action = "<cmd>nohlsearch<CR>";
          key = "<leader>qs";
          mode = "n";
        }
      ];
    };
  };
}
