{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.private;

  lanIpv4 = lib.network.lanIpv4 config "babs";

  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.private = {
    enable = mkEnableOption "Private";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/private" = {
      device = "${lanIpv4}:/tank1/private";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
