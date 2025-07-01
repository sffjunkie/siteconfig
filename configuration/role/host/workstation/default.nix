{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.workstation;
  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.role.workstation = {
    enable = mkEnableOption "workstation role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      admin = {
        mqtt = enabled;
        mqttx = enabled;
        mongodb = enabled;
      };

      device = {
        stadia = enabled;
        wacom.enable = false;
        yubikey = enabled;
      };

      role = {
        gui = enabled;
      };

      desktop = {
        notification.libnotify = enabled;
      };

      storage = {
        minio-client = enabled;
      };

      media = {
        pipewire = enabled;
      };

      network = {
        service = {
          sshd = enabled;
        };
        link = {
          bluetooth = enabled;
        };
      };

      service = {
        homepage-dashboard = enabled;
      };

      system = {
        font = enabled;
        keyring = enabled;
        nix-index = enabled;
      };
    };

    environment.systemPackages = [
      pkgs.deploy-rs
      pkgs.pinentry-gtk2
      pkgs.d-spy
    ];

    networking.networkmanager = enabled;
    networking.firewall.enable = false;

    services.libinput = enabled;
    services.pcscd = enabled;
  };
}
