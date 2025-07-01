{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.direnv;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.development.direnv = {
    enable = mkEnableOption "direnv";
  };

  config = mkIf cfg.enable {
    programs.direnv = enabled // {
      nix-direnv = enabled;
    };
  };
}
