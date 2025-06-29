{
  config = {
    programs.nixvim = {
      plugins.direnv = {
        enable = true;
      };
    };
  };
}
