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
      zfs.extraPools = [
        "tank0"
        "tank1"
      ];

      initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "mpt3sas"
        "uas"
        "usbhid"
        "sd_mod"
      ];
      initrd.kernelModules = [ ];
      kernelModules = [ "kvm-intel" ];
      extraModulePackages = [ ];
    };
  };
}
