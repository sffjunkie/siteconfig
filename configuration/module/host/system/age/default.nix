{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.age;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.system.age = {
    enable = mkEnableOption "age";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.age
    ];
  };
}
