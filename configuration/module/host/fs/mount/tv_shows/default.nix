{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.tv_shows;

  lanIpv4 = lib.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.tv_shows = {
    enable = mkEnableOption "TV Shows";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/tv_shows" = {
      device = "${lanIpv4}:/tank1/tv_shows";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
