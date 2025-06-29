{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.alejandra;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.alejandra = {
    enable = mkEnableOption "alejandra";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.alejandra
    ];
  };
}
