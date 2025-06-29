{ pkgs, ... }:
{
  config = {
    programs.nixvim = {
      plugins.dap-python = {
        adapterPythonPath = pkgs.python3;
      };
    };
  };
}
