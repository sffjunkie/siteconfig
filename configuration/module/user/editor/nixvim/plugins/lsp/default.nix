{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  imports = [
    ./python.nix
  ];

  config = {
    programs.nixvim = {
      plugins = {
        lsp = {
          enable = true;
          keymaps = {
            diagnostic = {
              "[d" = "goto_prev";
              "]d" = "goto_next";
            };
          };

          servers = {
            bashls = enabled;
            jsonls = enabled;
            lua_ls = enabled;
            nil_ls = enabled;
            yamlls = enabled;
          };
        };
      };
    };
  };
}
