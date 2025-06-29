{
  config = {
    programs.nixvim = {
      extraConfigLua = ''
        local searching_google_in_normal = [[:lua vim.fn.system({'xdg-open', 'https://google.com/search?q=' .. vim.fn.expand("<cword>")})<CR>]]
        map("n", "<C-q><C-g>", searching_google_in_normal, defaults)
      '';
    };
  };
}
