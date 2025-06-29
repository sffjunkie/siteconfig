{
  config,
  lib,
  pkgs,
  ...
}:
let
  vlans = config.looniversity.network.vlans;
  vlanDHCP = map (
    name:
    let
      vlanInfo = vlans.${name};

      vlanNetwork = lib.ipv4.constructIpv4Address config.looniversity.network.networkAddress "${toString vlanInfo.id}.0";

      vlanPoolStart = lib.ipv4.constructIpv4Address vlanNetwork (toString vlanInfo.dhcp_start);

      vlanPoolEnd = lib.ipv4.constructIpv4Address vlanNetwork (toString vlanInfo.dhcp_end);
    in
    {
      id = vlanInfo.id;
      subnet = lib.concatStringsSep "/" [
        vlanNetwork
        (toString vlanInfo.prefixLength)
      ];

      pools = [
        {
          pool = "${vlanPoolStart} - ${vlanPoolEnd}";
        }
      ];
    }
  ) (lib.attrNames vlans);
in
{
  config = {
    services.kea = {
      dhcp4 = {
        enable = true;

        settings = {
          authoritative = true;
          valid-lifetime = 7200;
          max-valid-lifetime = 86400;

          lease-database = {
            type = "memfile";
            persist = true;
            name = "/var/lib/kea/dhcp4.leases";
          };

          option-data = [
            {
              name = "domain-name";
              data = config.looniversity.network.domainName;
            }
            {
              name = "domain-name-servers";
              data = [
                config.looniversity.network.nameServer
              ] ++ config.looniversity.network.extraNameServers;
            }
            {
              name = "routers";
              data = "10.44.0.1";
            }
          ];

          hooks-libraries = [
            {
              library = "/usr/local/lib/kea/hooks/libdhcp_lease_cmds.so";
            }
          ];

          subnet4 = [
            {
              id = 1;
              subnet = lib.concatStringsSep "/" [
                "${config.looniversity.network.networkAddress}"
                "${toString config.looniversity.network.prefixLength}"
              ];
              pools = [
                { pool = "10.44.0.101 - 10.44.0.149"; }
              ];

              # TODO: Create dhcpstatic reservations
              # reservations = [
              #   {
              #     hostname = "sw1";
              #     hw-address = "10:da:43:d9:d9:d1";
              #     ip-address = "10.44.0.2";
              #   }
              # ];
            }
          ] ++ vlanDHCP;
        };
      };
    };
  };
}
