{
  config,
  lib,
  pkgs,
  ...
}:
let
  ns = "looniversity";
in
{
  config.looniversity.network = {
    networkAddress = "10.44.0.0";
    prefixLength = 21;
    domainName = "${ns}.net";
    ldapRoot = "dc=${ns},dc=net";
    nameServer = "10.44.0.1";
    extraNameServers = [
      "8.8.8.8"
      "1.1.1.1"
    ];
    workgroup = lib.toUpper ns;

    hosts = {
      # region Machines
      pinky = {
        description = "Admissions";
        netDevice = {
          wan = {
            device = "enp6s0";
            ipv4method = "pppoe";
          };
          lan = {
            device = "enp5s0";
            ipv4 = "10.44.0.1";
            ipv4method = "static";
          };
        };
      };
      thebrain = {
        description = "Service Centre";
        netDevice = {
          lan = {
            device = "eno1";
            ipv4 = "10.44.0.2";
            ipv4method = "dhcpstatic";
          };
        };
      };
      babs = {
        description = "Storage Server";
        netDevice = {
          lan = {
            device = "eno1";
            ipv4 = "10.44.0.3";
            ipv4method = "dhcpstatic";
          };
        };
      };
      furrball = {
        description = "Workstation";
        netDevice = {
          wifi = {
            device = "wlp3s0";
            ipv4method = "dhcp";
          };
        };
      };
      buster = {
        description = "Laptop";
        netDevice = {
          wifi = {
            device = "TBC"; # TODO: Add correct wifi device
            ipv4method = "dhcp";
          };
        };
      };
      mary = {
        description = "Music Server";
        netDevice = {
          lan = {
            device = "enp5s0";
            ipv4 = "10.44.0.4";
            ipv4method = "dhcpstatic";
          };
        };
      };
      calamity = {
        description = "Backup Server";
        netDevice = {
          lan = {
            device = "enp5s0";
            ipv4 = "10.44.0.5";
            ipv4method = "dhcpstatic";
          };
        };
      };
      # endregion

      # region Switches
      sw1 = {
        description = "Node0 Switch";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.10";
            ipv4method = "dhcpstatic";
          };
        };
      };
      # endregion

      # region Wifi access points
      wa1 = {
        description = "Downstairs WAP";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.11";
            ipv4method = "dhcpstatic";
          };
        };
      };
      wa2 = {
        description = "Upstairs WAP";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.12";
            ipv4method = "dhcpstatic";
          };
        };
      };
      wr1 = {
        description = "HiFi Repeater";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.13";
            ipv4method = "dhcpstatic";
          };
        };
      };
      # endregion

      # region IoT
      philips-hue = {
        description = "Philips Hue";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.21";
            ipv4method = "dhcpstatic";
          };
        };
      };
      # endregion

      # region Media devices
      gh-bedroom = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.50";
            ipv4method = "dhcpstatic";
          };
        };
      };
      gh-mediaroom = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.51";
            ipv4method = "dhcpstatic";
          };
        };
      };
      gh-dressingroom = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.52";
            ipv4method = "dhcpstatic";
          };
        };
      };
      gh-kitchen = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.53";
            ipv4method = "dhcpstatic";
          };
        };
      };
      gh-lounge = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.54";
            ipv4method = "dhcpstatic";
          };
        };
      };
      gh-garage = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.55";
            ipv4method = "dhcpstatic";
          };
        };
      };
      ca-kitchen = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.60";
            ipv4method = "dhcpstatic";
          };
        };
      };
      ca-garage = {
        netDevice = {
          lan = {
            ipv4 = "10.44.0.61";
            ipv4method = "dhcpstatic";
          };
        };
      };
      cxn-lounge = {
        description = "CXNv2";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.62";
            ipv4method = "dhcpstatic";
          };
        };
      };
      gtv-bedroom = {
        description = "Google TV";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.63";
            ipv4method = "dhcpstatic";
          };
        };
      };
      sb-mediaroom = {
        description = "Sonos Beam";
        netDevice = {
          lan = {
            ipv4 = "10.44.0.64";
            ipv4method = "dhcpstatic";
          };
        };
      };
      # endregion
    };

    vlans = {
      guest = {
        id = 10;
        networkAddress = "10.44.10.0";
        prefixLength = 24;
      };
      iot = {
        id = 20;
        networkAddress = "10.44.20.0";
        prefixLength = 24;
      };
      not = {
        id = 30;
        networkAddress = "10.44.30.0";
        prefixLength = 24;
      };
    };

    services = {
      ca = {
        handlerName = "step-ca";
        addToDns = true;
      };
      cloud.handlerName = "nextcloud";
      dhcp4.handlerName = "kea";
      dns.handlerName = "coredns";
      git.handlerName = "gitea";
      home-automation.handlerName = "home-assistant";
      log.handlerName = "loki";
      metrics.handlerName = "prometheus";
      music.handlerName = "jellyfin";
      proxy.handlerName = "traefik";
      smb.handlerName = "samba";
      s3.handlerName = "minio";
      sync.handlerName = "syncthing";
      zigbee.handlerName = "zigbee2mqtt";
    };

    serviceHandlers = {
      camo = {
        # host = "thebrain";
        host = "127.0.0.1";
        port = "8081";
      };

      # region Network
      coredns = {
        host = "pinky";
        port = 53;
        config = {
          dynamicZoneDataDir = "/var/lib/coredns/dynamic";
        };
      };

      traefik = {
        host = "pinky";
        ports = {
          dashboard = 8080;
        };
      };

      kea = {
        host = "pinky";
        port = 67;
      };
      # endregion

      # region Monitoring
      grafana = {
        # host = "thebrain";
        host = "10.44.0.2";
        port = 9100;
      };

      prometheus = {
        # host = "thebrain";
        host = "10.44.0.2";
        port = 9101;
      };

      alloy = {
        port = 9103;
      };

      loki = {
        # host = "thebrain";
        host = "10.44.0.2";
        port = 9102;
      };

      elasticsearch = {
        # host = "thebrain";
        host = "127.0.0.1";
      };

      graylog = {
        # host = "thebrain";
        host = "127.0.0.1";
        port = 9013;
      };
      #endregion

      gitea = {
        # host = "thebrain";
        host = "127.0.0.1";
        port = 3000;
      };

      # region home-automation
      home-assistant = {
        # host = "thebrain";
        host = "127.0.0.1";
        port = 8123;
      };

      mosquitto = {
        host = "10.44.1.1";
      };

      zigbee2mqtt = {
        # host = "thebrain";
        host = "127.0.0.1";
        port = 8080;
      };
      # endregion

      minio = {
        host = "babs";
        ports = {
          listen = 9011;
          console = 9012;
        };
      };

      # region Database
      postgresql = {
        package = pkgs.postgresql_17;
        # host = "thebrain";
        host = "10.44.0.2";
        port = 5432;
      };

      mongodb = {
        # host = "thebrain";
        host = "127.0.0.1";
      };
      # endregion

      nextcloud = {
        # host = "thebrain";
        host = "127.0.0.1";
      };

      homepage-dashboard = {
        port = 9014;
      };

      jellyfin = {
        host = "mary";
        ports = {
          ui = 8096;
          ui_https = 8920;
        };
      };

      portainer = {
        # host = "thebrain";
        host = "127.0.0.1";
        port = 9000;
      };

      step-ca = {
        host = "pinky";
      };

      syncthing.host = "babs";
    };
  };
}
