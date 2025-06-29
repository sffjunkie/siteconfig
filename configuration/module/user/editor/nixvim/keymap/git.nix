{
  config = {
    programs.nixvim = {
      keymaps = [
        {
          action = ":Neogit<CR>";
          key = "<leader>gg";
          mode = "n";
        }
        {
          action = ":Neogit log h<CR>";
          key = "<leader>gl";
          mode = "n";
          options = {
            desc = "Git log";
          };
        }
        {
          action = ":Neogit Pull<CR>";
          key = "<leader>gp";
          mode = "n";
          options = {
            desc = "Git pull";
          };
        }
        {
          action = ":Neogit Push<CR>";
          key = "<leader>gP";
          mode = "n";
          options = {
            desc = "Git push";
          };
        }
        {
          action = ":DiffviewOpen HEAD<CR>";
          key = "<leader>gdh";
          mode = "n";
          options = {
            desc = "View diff against HEAD";
          };
        }
        {
          action = ":DiffviewOpen develop<CR>";
          key = "<leader>gdd";
          mode = "n";
          options = {
            desc = "View diff against develop branch";
          };
        }
        {
          action = ":DiffviewOpen origin/main...HEAD<CR>";
          key = "<leader>gdo";
          mode = "n";
          options = {
            desc = "View diff origin/main against HEAD";
          };
        }
      ];
    };
  };
}
