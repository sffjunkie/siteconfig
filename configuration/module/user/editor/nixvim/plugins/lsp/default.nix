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
            bashls.enable = true;
            jsonls.enable = true;
            lua_ls.enable = true;
            nil_ls.enable = true;
            yamlls.enable = true;
          };
        };
      };
    };
  };
}
