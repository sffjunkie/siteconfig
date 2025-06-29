{ pkgs, ... }:
{
  config = {
    programs.nixvim = {
      plugins.notify = {
        enable = true;
      };
    };
  };
}
