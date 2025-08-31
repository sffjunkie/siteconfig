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
      supportedFilesystems = [
        "zfs"
        "exfat"
      ];

      initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "uas"
        "sd_mod"
      ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };
  };
}
