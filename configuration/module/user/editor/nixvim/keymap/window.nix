{
  config = {
    programs.nixvim = {
      keymaps = [
        {
          action = "<C-w><C-h>";
          key = "<C-h>";
          mode = "n";
        }
        {
          action = "<C-w><C-h>";
          key = "<C-left>";
          mode = "n";
        }
        {
          action = "<C-w><C-j>";
          key = "<C-j>";
          mode = "n";
        }
        {
          action = "<C-w><C-k>";
          key = "<C-k>";
          mode = "n";
        }
        {
          action = "<C-w><C-l>";
          key = "<C-right>";
          mode = "n";
        }
      ];
    };
  };
}
