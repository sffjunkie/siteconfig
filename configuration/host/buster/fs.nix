{
  config = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/fd6220a6-9172-4d93-aa50-c7161bc2a3c7";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/77E2-184D";
      fsType = "vfat";
    };

    fileSystems."/home" = {
      device = "tank0/home";
      fsType = "zfs";
    };

    swapDevices = [
      { device = "/dev/disk/by-uuid/58bbe9f7-4602-4e45-ac95-99eeddd42b81"; }
    ];
  };
}
