{
  config = {
    fileSystems."/" = {
      # TODO: Add correct partuuid
      device = "/dev/disk/by-partuuid/";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      # TODO: Add correct partuuid
      device = "/dev/disk/by-partuuid/";
      fsType = "vfat";
    };

    swapDevices = [ ];
  };
}
