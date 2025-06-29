{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.backup;

  lanIpv4 = lib.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.backup = {
    enable = mkEnableOption "backup mount";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/backup" = {
      device = "${lanIpv4}:/tank0/backup";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
