{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  config = {
    programs.nixvim = {
      plugins.telescope = {
        enable = true;
        extensions = {
          file-browser = enabled;
          fzf-native = enabled;
        };

        keymaps = {
          "<leader>ff" = {
            action = "find_files";
            options = {
              desc = "Search for files";
            };
          };
          "<leader>fg" = {
            action = "live_grep";
            options = {
              desc = "Search with grep";
            };
          };

          "<leader>fb" = {
            action = "buffers";
            options = {
              desc = "Search buffers";
            };
          };
          "<leader>fh" = {
            action = "help_tags";
            options = {
              desc = "Search help";
            };
          };
        };
      };
    };
  };
}
