{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.nix-index;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.nix-index = {
    enable = mkEnableOption "nix-index";
  };

  config = mkIf cfg.enable {
    programs.nix-index = {
      enable = true;
      enableZshIntegration = false;
      enableBashIntegration = false;
    };
  };
}
