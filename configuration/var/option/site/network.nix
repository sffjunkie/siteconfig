{
  config,
  lib,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  netDevice = types.submodule {
    options = {
      device = mkOption {
        type = types.str;
        default = "";
        description = "The network device interface name";
      };
      mac = mkOption {
        type = types.str;
        default = "";
        description = "The MAC address of the interface";
      };
      ipv4 = mkOption {
        type = types.str;
        default = "";
        description = "IPv4 address to assign to the interface";
      };
      ipv4method = mkOption {
        type = types.enum [
          "static"
          "dhcpstatic"
          "dhcp"
          "pppoe"
        ];
        default = "";
        description = "The method to be used to obtain an IP address";
      };
    };
  };

  host = types.submodule (
    { name, ... }:
    {
      options = {
        name = mkOption {
          type = types.str;
          default = name;
          description = "The name to assign to the host";
        };
        description = mkOption {
          type = types.str;
          default = "";
          description = "A description of the host";
        };
        netDevice = mkOption {
          type = types.attrsOf netDevice;
          description = "Named network devices. Normally at least a 'lan' device should be defined";
          default = { };
        };
      };
    }
  );

  vlan = types.submodule {
    options = {
      id = mkOption {
        type = types.int;
        description = "The VLAN Tag id to assign";
      };
      networkAddress = mkOption {
        type = types.str;
        default = "";
        description = "The network address of the VLAN";
      };
      prefixLength = mkOption {
        type = types.int;
        default = 24;
        description = "The prefix length of the network";
      };
      dhcp_start = mkOption {
        type = types.int;
        default = 101;
        description = "The starting IP of the DHCP pool";
      };
      dhcp_end = mkOption {
        type = types.int;
        default = 150;
        description = "The ending IP of the DHCP pool";
      };
      dhcp_reservations = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of hosts to create static DHCP reservations for";
      };
    };
  };

  service = types.submodule (
    { name }:
    {
      options = {
        host = mkOption {
          type = types.str;
          default = name;
          description = "The host name to assign to the service";
        };
        domainName = mkOption {
          type = types.str;
          default = "service.${config.looniversity.network.domainName}";
          description = "The domain name to assign to the service";
        };
        addToDns = mkOption {
          type = types.bool;
          default = false;
          description = "Set to true to add this service to DNS";
        };
        addToProxy = mkOption {
          type = types.bool;
          default = false;
          description = "Set to true to add this service to the reverse proxy";
        };
        handlerName = mkOption {
          type = types.str;
          description = "The name of the service handler for this service";
        };
      };
    }
  );

  serviceHandler = types.submodule {
    options = {
      package = mkOption {
        type = types.package;
        description = "The nixpkgs package for this service handler";
      };
      host = mkOption {
        type = types.str;
        description = "The host on which to run this service handler";
      };
      port = mkOption {
        type = types.int;
        default = -1;
        description = "The main port to access the service";
      };
      ports = mkOption {
        type = types.attrsOf types.int;
        default = { };
        description = "Named ports for things such as UIs";
      };
      config = mkOption {
        type = types.attrsOf types.anything;
        default = { };
      };
    };
  };
in
{
  options.looniversity.network = {
    networkAddress = mkOption {
      type = types.str;
      default = "192.168.0.0";
      description = "The main IP network";
    };

    prefixLength = mkOption {
      type = types.int;
      default = 24;
      description = "The main IP network prefix length";
    };

    domainName = mkOption {
      type = types.str;
      default = "network.arpa";
      description = "The main IP domain name";
    };

    ldapBaseDN = mkOption {
      type = types.str;
      default = "";
      description = "LDAP root";
    };

    nameServer = mkOption {
      type = types.str;
      default = "";
    };

    extraNameServers = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    workgroup = mkOption {
      type = types.str;
      default = "";
      description = "Samba workgroup";
    };

    hosts = mkOption {
      type = types.attrsOf host;
      default = { };
      description = "The hosts on the network";
    };

    services = mkOption {
      type = types.attrsOf service;
      default = { };
      description = "Service definitions";
    };

    serviceHandlers = mkOption {
      type = types.attrsOf serviceHandler;
      default = { };
      description = "Service handler definitions";
    };

    vlans = mkOption {
      type = types.attrsOf vlan;
      default = { };
      description = "VLANs to create";
    };
  };
}
