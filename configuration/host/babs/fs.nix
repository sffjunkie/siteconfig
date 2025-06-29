# ZFS filesystems are mounted using zfs.extraPools in boot.nix
{
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-partuuid/01e0f4ad-4043-c34b-9e24-1a02b123c1b9";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-partuuid/b777f8bc-1be5-bb41-8631-299ec100f3f3";
      fsType = "vfat";
    };

    swapDevices = [ ];
  };
}
