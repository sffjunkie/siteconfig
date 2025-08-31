{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.deploy.nixos-anywhere;

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.deploy.nixos-anywhere = {
    enable = mkEnableOption "nixos-anywhere";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.nixos-anywhere
    ];
  };
}
