{
  config = {
    programs.nixvim = {
      plugins.which-key = {
        enable = true;
        settings.plugins.spelling.enabled = true;
      };
    };
  };
}
