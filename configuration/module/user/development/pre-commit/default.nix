{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.pre-commit;
  inherit (lib) mkDefault mkEnableOption mkIf;
in
{
  options.looniversity.development.pre-commit = {
    enable = mkEnableOption "pre-commit";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.pre-commit
    ];
  };
}
