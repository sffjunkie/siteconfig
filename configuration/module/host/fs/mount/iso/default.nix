{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.mount.iso;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.mount.iso = {
    enable = mkEnableOption "ISO";
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/iso" = {
      device = "10.44.0.3:/tank0/iso";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.requires=network-online.target"
        "noauto"
      ];
    };
  };
}
