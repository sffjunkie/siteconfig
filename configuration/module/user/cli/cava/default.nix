{
  pkgs,
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.looniversity.cli.cava;
in
{
  options.looniversity.cli.cava = {
    enable = options.programs.cava.enable;
    settings = options.programs.cava.settings;
  };

  config = lib.mkIf cfg.enable {
    programs.cava = {
      enable = config.looniversity.cli.cava.enable;
      settings = config.looniversity.cli.cava.settings;
    };
  };
}
