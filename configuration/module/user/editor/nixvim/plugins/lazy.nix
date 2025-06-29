{
  config = {
    programs.nixvim = {
      lazy.plugins = {
        sleuth = {
          enable = true;
        };
      };
    };
  };
}
