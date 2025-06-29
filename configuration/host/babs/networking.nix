{
  config,
  lib,
  ...
}:
let
  lanDev = lib.network.netDevice config "babs" "lan";
in
{
  config = {
    networking = {
      hostId = "fafececd";
      hostName = "babs";
      domain = "looniversity.net";
      useDHCP = lib.mkDefault false;
    };

    systemd.network = {
      enable = true;

      networks = {
        lan = {
          matchConfig.Name = lanDev;
          networkConfig = {
            DHCP = "ipv4";
          };
        };
      };

      links = {
        lan = {
          matchConfig.Name = "lan";
          linkConfig = {
            GenericSegmentationOffload = false;
            GenericReceiveOffload = false;
            TCPSegmentationOffload = false;
            WakeOnLan = "magic";
          };
        };
      };
    };
  };
}
