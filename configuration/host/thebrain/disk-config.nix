{
  disk0 ? "/dev/sda",
  ...
}:
{
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = "${disk0}";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            primary = {
              size = "100%FREE";
              type = "filesystem";
              content = {
                type = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
