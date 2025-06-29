{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.roms;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.roms = {
    enable = mkEnableOption "roms";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/roms" = {
      device = "10.44.0.3:/tank1/roms";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
