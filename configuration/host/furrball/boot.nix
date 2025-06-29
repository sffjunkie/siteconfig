{ lib, ... }:
{
  config = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 5;
        };
        efi.canTouchEfiVariables = true;
      };
      supportedFilesystems = [ "zfs" ];

      initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "uas"
        "usbhid"
        "sd_mod"
      ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
    };
  };
}
