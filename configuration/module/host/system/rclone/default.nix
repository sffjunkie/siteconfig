# TODO: tmpfiles, /var
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.system.rclone;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.looniversity.system.rclone = {
    enable = mkEnableOption "rclone";
  };

  config = mkIf cfg.enable {
    sops.secrets."rclone/ini" = {
      sopsFile = config.sopsFiles.service;
    };

    environment.variables = {
      "RCLONE_CONFIG" = "/var/lib/rclone/rclone.conf";
    };

    environment.systemPackages = [
      pkgs.rclone
      pkgs.fuse
      pkgs.fuse3
    ];

    systemd.services = {
      "rclone@" = {
        path = [
          pkgs.fuse3
        ];
        description = "rclone mount.";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        environment = {
          RCLONE_CONFIG = "%S/rclone.conf";
        };

        serviceConfig = {
          Type = "simple";

          ExecStartPre = [
            "${pkgs.coreutils}/bin/mkdir -p /var/lib/rclone/mnt/%i"
            "${pkgs.coreutils}/bin/cp ${config.sops.secrets."rclone/ini".path} /var/lib/rclone/rclone.conf"
          ];
          ExecStart = "${pkgs.rclone}/bin/rclone --config=/var/lib/rclone/rclone.conf --log-level INFO --log-file /tmp/rclone-%i.log mount --umask 022 --allow-other %i: /var/lib/rclone/mnt/%i";
          ExecStop = "${pkgs.fuse3}/bin/fusermount3 -u /var/lib/rclone/mnt/%i";

          StateDirectory = "rclone";
        };
      };
    };
  };
}
