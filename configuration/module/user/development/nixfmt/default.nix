{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.development.nixfmt;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.development.nixfmt = {
    enable = mkEnableOption "nixfmt";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.nixfmt-rfc-style
    ];
  };
}
