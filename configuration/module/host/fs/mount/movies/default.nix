{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.movies;

  lanIpv4 = lib.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.movies = {
    enable = mkEnableOption "Movies";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/movies" = {
      device = "${lanIpv4}:/tank1/movies";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
