{
  config,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.looniversity.role.laptop;
in
{
  options.looniversity.role.laptop = {
    enable = mkEnableOption "laptop role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      role = {
        gui.enable = true;
      };

      desktop = {
        notification.libnotify.enable = true;
      };

      device = {
        yubikey.enable = true;
      };

      media = {
        pipewire.enable = true;
      };

      network = {
        link = {
          bluetooth.enable = true;
        };
      };

      service = {
        homepage-dashboard.enable = true;
      };

      system = {
        keyring.enable = true;
        font.enable = true;
      };
    };

    environment.systemPackages = [
      pkgs.pinentry-gtk2
    ];

    boot.initrd.kernelModules = [
      "intel_lpss"
      "intel_lpss_pci"
      "8250_dw"
      "pinctrl_icelake"
      "surface_aggregator"
      "surface_aggregator_registry"
      "surface_aggregator_hub"
      "surface_hid_core"
      "surface_hid"
    ];
    # nixos-hardware.microsoft-surface.ipts.enable = true;

    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    services.libinput.enable = true;
    services.pcscd.enable = true;
    services.upower.enable = true;
  };
}
