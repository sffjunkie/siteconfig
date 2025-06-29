{
  config = {
    programs.nixvim = {
      extraConfigLuaPre = ''
        local map = vim.keymap.set
        local set = vim.opt
        local defaults = { noremap = true, silent = true }
      '';
    };
  };
}
