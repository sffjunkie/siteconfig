{
  config = {
    programs.nixvim = {
      autoCmd = [
        {
          event = "TextYankPost";
          group = "vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true })";
        }
      ];
    };
  };
}
