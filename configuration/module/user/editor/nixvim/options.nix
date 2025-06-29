{
  config = {
    programs.nixvim = {
      opts = {
        breakindent = true;
        clipboard = "unnamedplus";
        cursorline = true;
        ignorecase = true;
        inccommand = "split";
        list = true;
        listchars = {
          tab = "» ";
          trail = "·";
          nbsp = "␣";
        };
        mouse = "a";
        number = true;
        scrolloff = 10;
        showmode = false;
        showtabline = 2;
        signcolumn = "yes";
        smartcase = true;
        splitbelow = true;
        splitright = true;
        timeoutlen = 300;
        undofile = true;
        updatetime = 250;
      };
    };
  };
}
