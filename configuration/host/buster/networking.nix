{ lib, config, ... }:
let
  lanDev = lib.network.netDevice config "buster" "wifi";
in
{
  config = {
    networking = {
      hostId = "e9313abd";
      hostName = "buster";
      domain = config.looniversity.network.domainName;
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
    };
  };
}
