{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.gui.obsidian;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.gui.obsidian = {
    enable = mkEnableOption "obsidian";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.obsidian
    ];
  };
}
