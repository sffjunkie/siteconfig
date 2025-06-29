{ lib, pkgs, ... }@inputs:
let
  testData = {
    config = {
      looniversity.network = {
        networkAddress = "192.168.1.0";
        prefixLength = 21;
        domainName = "home.arpa";

        hosts = {
          host_a = {
            netDevice = {
              lan = {
                device = "eth1";
                ipv4 = "192.168.1.1";
                ipv4method = "dhcpstatic";
                mac = "48:d6:32:db:83:de";
              };
            };
          };
        };

        services = {
          ca.handler = "step-ca";
          cloud.handler = "nextcloud";
          mail = {
            domainName = "lan.arpa";
          };
        };

        serviceHandlers = {
          nextcloud = {
            hostName = "cloud";
            port = 80;
          };

          postgresql = {
            package = pkgs.postgresql_15;
          };

          step-ca = {
            hostName = "bigbox";
            ports = {
              ui = 8080;
            };
          };
        };
      };
    };
  };
in
[
  {
    name = "domainName";
    actual = lib.network.domainName testData.config;
    expected = "home.arpa";
  }
  {
    name = "network.netDevice";
    actual = lib.network.netDevice testData.config "host_a" "lan";
    expected = "eth1";
  }
  {
    name = "network.netDevice.badDevice";
    actual = lib.network.netDevice testData.config "host_a" "lana";
    expected = null;
  }
  {
    name = "network.netDevice.badHost";
    actual = lib.network.netDevice testData.config "host_b" "lan";
    expected = null;
  }
  {
    name = "network.lanIpv4";
    actual = lib.network.lanIpv4 testData.config "host_a";
    expected = "192.168.1.1";
  }
  {
    name = "network.lanIpv4.badHost";
    actual = lib.network.lanIpv4 testData.config "host_b";
    expected = null;
  }
  {
    name = "network.service.domainName";
    actual = lib.network.serviceDomainName testData.config "mail";
    expected = "lan.arpa";
  }
  {
    name = "network.service.domainName.default";
    actual = lib.network.serviceDomainName testData.config "cloud";
    expected = "home.arpa";
  }
  {
    name = "network.serviceHandler";
    actual = lib.network.serviceHandler testData.config "nextcloud";
    expected = {
      hostName = "cloud";
      port = 80;
    };
  }
  {
    name = "network.serviceHandler.nonexistent";
    actual = lib.network.serviceHandler testData.config "aservice";
    expected = { };
  }
  {
    name = "network.serviceHandlerMainPort";
    actual = lib.network.serviceHandlerMainPort testData.config "nextcloud";
    expected = 80;
  }
  {
    name = "network.serviceHandlerNamedPort";
    actual = lib.network.serviceHandlerNamedPort testData.config "step-ca" "ui";
    expected = 8080;
  }
  {
    name = "network.serviceHandlerHost";
    actual = lib.network.serviceHandlerHost testData.config "nextcloud";
    expected = "cloud";
  }
  {
    name = "network.serviceHandlerHost";
    actual = lib.network.serviceHandlerHost testData.config "step-ca";
    expected = "bigbox";
  }
  {
    name = "network.serviceHandlerFQDN";
    actual = lib.network.serviceHandlerFQDN testData.config "step-ca";
    expected = "bigbox.home.arpa";
  }
  {
    skip = "Need to find out how config values are linked to options so that we can test for defaults";
    name = "network.serviceHostName";
    actual = lib.network.serviceHostName testData.config "ca";
    expected = "ca";
  }
  {
    name = "network.serviceServiceHandlerName";
    actual = lib.network.serviceServiceHandlerName testData.config "ca";
    expected = "step-ca";
  }
]
