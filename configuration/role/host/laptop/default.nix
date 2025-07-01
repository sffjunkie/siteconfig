{
  config,
  lib,
  nixos-hardware,
  pkgs,
  ...
}:
let
  cfg = config.looniversity.role.laptop;

  inherit (lib) enabled mkEnableOption mkIf;
in
{
  options.looniversity.role.laptop = {
    enable = mkEnableOption "laptop role";
  };

  config = mkIf cfg.enable {
    looniversity = {
      role = {
        gui = enabled;
      };

      desktop = {
        notification.libnotify = enabled;
      };

      device = {
        yubikey = enabled;
      };

      media = {
        pipewire = enabled;
      };

      network = {
        link = {
          bluetooth = enabled;
        };
      };

      service = {
        homepage-dashboard = enabled;
      };

      system = {
        keyring = enabled;
        font = enabled;
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
    # nixos-hardware.microsoft-surface.ipts= enabled;

    networking.networkmanager = enabled;
    networking.firewall.enable = false;

    services.libinput = enabled;
    services.pcscd = enabled;
    services.upower = enabled;
  };
}
