{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.workstation;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.looniversity.role.workstation = {
    enable = mkEnableOption "workstation role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      admin = {
        mqtt.enable = true;
        mqttx.enable = true;
        mongodb.enable = true;
      };

      device = {
        stadia.enable = true;
        wacom.enable = false;
        yubikey.enable = true;
      };

      role = {
        gui.enable = true;
      };

      desktop = {
        notification.libnotify.enable = true;
      };

      storage = {
        minio-client.enable = true;
      };

      media = {
        pipewire.enable = true;
      };

      network = {
        service = {
          sshd.enable = true;
        };
        link = {
          bluetooth.enable = true;
        };
      };

      service = {
        homepage-dashboard.enable = true;
      };

      system = {
        font.enable = true;
        keyring.enable = true;
        nix-index.enable = true;
      };
    };

    environment.systemPackages = [
      pkgs.deploy-rs
      pkgs.pinentry-gtk2
      pkgs.d-spy
    ];

    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    services.libinput.enable = true;
    services.pcscd.enable = true;
  };
}
