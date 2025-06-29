{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.music;

  lanIpv4 = lib.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.music = {
    enable = mkEnableOption "music";
    automount = mkEnableOption "automount";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/music" = {
      device = "${lanIpv4}:/tank0/music";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
