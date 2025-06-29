{
  config = {
    programs.nixvim = {
      plugins.treesitter = {
        enable = true;
      };
    };
  };
}
