{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.doc.mystmd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.doc.mystmd = {
    enable = mkEnableOption "mystmd";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.mystmd
      pkgs.nodejs
    ];
  };
}
