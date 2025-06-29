{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.direnv;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
