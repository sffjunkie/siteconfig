{
  imports = [
    ./git.nix
    ./google.nix
    ./tabs.nix
    ./window.nix
  ];

  config = {
    programs.nixvim = {
      keymaps = [
        {
          action = ":write<CR>";
          key = "<Leader>w";
          mode = "n";
          options = {
            desc = "Write buffer";
          };
        }
        {
          action = ":wqa<CR>";
          key = "<Leader>a";
          mode = "n";
          options = {
            desc = "Write all buffers and quit";
          };
        }
        {
          action = ":wq<CR>";
          key = "<Leader>x";
          mode = "n";
          options = {
            desc = "Write buffer and quit";
          };
        }
        {
          action = ":qa!<CR>";
          key = "<Leader>X";
          mode = "n";
          options = {
            desc = "Just quit";
          };
        }
        {
          action = "<C-r>";
          key = "U";
          mode = "n";
          options = {
            desc = "Redo";
          };
        }
        {
          action = "<C-u>";
          key = "m";
          mode = "n";
          options = {
            desc = "Scroll up";
            noremap = true;
            silent = true;
          };
        }
        {
          action = "<C-d>";
          key = ",";
          mode = "n";
          options = {
            desc = "Scroll down";
            noremap = true;
            silent = true;
          };
        }
        {
          action = "<C-u>";
          key = "<C-Up>";
          mode = "n";
          options = {
            desc = "Scroll up";
            noremap = true;
            silent = true;
          };
        }
        {
          action = "<C-d>";
          key = "<C-Down>";
          mode = "n";
          options = {
            desc = "Scroll down";
            noremap = true;
            silent = true;
          };
        }
        {
          action = '':<C-u>call append(line("."), repeat([" "], v:count1))<CR>'';
          key = "<leader>o";
          mode = "n";
          options = {
            desc = "Add blank line before";
            noremap = true;
            silent = true;
          };
        }
        {
          action = '':<C-u>call append(line(".")-1, repeat([" "], v:count1))<CR>'';
          key = "<leader>O";
          mode = "n";
          options = {
            desc = "Add blank line after";
            noremap = true;
            silent = true;
          };
        }
        {
          action = ":keepjumps normal! ggyG<CR>";
          key = "<leader>C";
          mode = "n";
          options = {
            desc = "Select all text in the current buffer";
            noremap = true;
            silent = true;
          };
        }
        {
          action = "yyddkP";
          key = "<S-Up>";
          mode = "n";
          options = {
            desc = "Shift line up";
            noremap = true;
            silent = true;
          };
        }
        {
          action = "yyddkp";
          key = "<S-Down>";
          mode = "n";
          options = {
            desc = "Shift line down";
            noremap = true;
            silent = true;
          };
        }
        {
          action = "<cmd>nohlsearch<CR>";
          key = "<Esc>";
          mode = "n";
        }
        {
          action = ":NvimTreeFindFileToggle<CR>";
          key = "<leader>e";
          mode = "n";
          options = {
            desc = "Toggle file tree";
          };
        }
        {
          action = ":MarkdownPreviewToggle<CR>";
          key = "<leader>mp";
          mode = "n";
          options = {
            desc = "Toggle markdown preview";
          };
        }
        {
          action = ":CommentToggle<CR>";
          key = "<leader>/";
          mode = [
            "n"
            "v"
          ];
          options = {
            desc = "Toggle comments";
          };
        }
      ];
    };
  };
}
