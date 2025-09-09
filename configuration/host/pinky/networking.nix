{
  config,
  lib,
  ...
}:
let
  wanDev = lib.network.netDevice config "pinky" "wan";
  lanDev = lib.network.netDevice config "pinky" "lan";
  lanIp = lib.ipv4.constructIpv4Address config.looniversity.network.networkAddress "1";

  vlanDefs = config.looniversity.network.vlans;

  vlanNetDevs = lib.mapAttrs' (
    name: value:
    lib.nameValuePair name {
      netdevConfig = {
        Name = "${lanDev}.${toString value.id}";
        Kind = "vlan";
      };
      vlanConfig = {
        Id = value.id;
      };
    }
  ) config.looniversity.network.vlans;

  vlanNetworks = lib.mapAttrs' (
    name: value:
    lib.nameValuePair name {
      matchConfig = {
        Name = "${lanDev}.${toString value.id}";
      };
      networkConfig = {
        DHCP = "no";
      };
      address = [
        "${value.networkAddress}/${toString value.prefixLength}"
      ];
    }
  ) config.looniversity.network.vlans;
in
{
  config = {
    networking = {
      hostId = "dbe3c39e";
      hostName = "pinky";

      domain = config.looniversity.network.domainName;
      useDHCP = lib.mkDefault false;
    };

    systemd.network = {
      enable = true;

      netdevs = vlanNetDevs;

      networks = {
        wan = {
          matchConfig.Name = wanDev;
          networkConfig = {
            DHCP = false;
          };
        };
        lan = {
          matchConfig.Name = lanDev;
          networkConfig = {
            DHCP = false;
            VLAN = lib.attrNames vlanDefs;
          };
          address = [ "${lanIp}/${toString config.looniversity.network.prefixLength}" ];
        };
      }
      // vlanNetworks;
    };
  };
}
