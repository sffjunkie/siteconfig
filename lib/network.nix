{
  lib,
  ns ? "looniversity",
  ...
}:
let
  # Return the domain name for the specified namespace
  domainName =
    config:
    lib.attrByPath [
      ns
      "network"
      "domainName"
    ] "home.arpa" config;

  # Gets a hosts network device given an alias
  # netDevice :: attrSet -> str -> str -> str
  netDevice =
    config: hostname: ifname:
    lib.attrByPath [
      ns
      "network"
      "hosts"
      hostname
      "netDevice"
      ifname
      "device"
    ] null config;

  # lanIpv4 :: attrSet -> str -> str
  # Get the ipv4 address of the host's lan network device
  lanIpv4 =
    config: host:
    lib.attrByPath [
      ns
      "network"
      "hosts"
      host
      "netDevice"
      "lan"
      "ipv4"
    ] null config;

  # serviceHandler :: attrSet -> str -> attrSet
  # Get the service handler definition for the `serviceHandlerName`
  serviceHandler =
    config: serviceHandlerName:
    lib.attrByPath [
      ns
      "network"
      "serviceHandlers"
      serviceHandlerName
    ] { } config;

  # serviceHandlerMainPort :: attrSet -> str -> str -> int
  # Get a named port number for the `serviceHandlerName`
  serviceHandlerMainPort =
    config: serviceHandlerName:
    let
      handler = serviceHandler config serviceHandlerName;
    in
    lib.attrByPath [
      "port"
    ] (-1) handler;

  # serviceHandlerNamedPort :: attrSet -> str -> str -> int
  # Get a named port number for the `serviceHandlerName`
  serviceHandlerNamedPort =
    config: serviceHandlerName: portName:
    let
      handler = serviceHandler config serviceHandlerName;
    in
    lib.attrByPath [
      "ports"
      portName
    ] (-1) handler;

  # serviceHandlerHost :: attrSet -> str -> str
  # Get the host name for the `serviceName`
  serviceHandlerHost =
    config: serviceHandlerName:
    let
      handler = serviceHandler config serviceHandlerName;
    in
    lib.attrByPath [
      "host"
    ] null handler;

  # serviceHandlerFQDN :: attrSet -> str -> str
  serviceHandlerFQDN =
    config: serviceHandlerName:
    let
      hostName = serviceHandlerHost config serviceHandlerName;
    in
    if hostName != null then
      lib.concatStringsSep "." [
        hostName
        (domainName config)
      ]
    else
      null;

  service =
    config: serviceName:
    lib.attrByPath [
      ns
      "network"
      "services"
      serviceName
    ] { } config;

  # serviceHostName :: attrSet -> str -> str
  serviceHostName =
    config: serviceName:
    let
      serviceInfo = service config serviceName;
    in
    lib.attrByPath [
      "hostName"
    ] null serviceInfo;

  # serviceDomainName :: attrSet -> str -> str
  serviceDomainName =
    config: serviceName:
    let
      serviceInfo = service config serviceName;
    in
    lib.attrByPath [
      "domainName"
    ] (domainName config) serviceInfo;

  # serviceFQDN :: attrSet -> str -> str
  serviceFQDN =
    config: serviceName:
    lib.concatStringsSep "." [
      (serviceHostName config serviceName)
      (serviceDomainName config serviceName)
    ];

  # Return the service handler associated with a service
  # serviceServiceHandlerName :: attrSet -> str -> str
  serviceServiceHandlerName =
    config: serviceName:
    lib.attrByPath [
      ns
      "network"
      "services"
      serviceName
      "handler"
    ] null config;

  # Return the service handler package associated with a service
  # serviceServiceHandlerPackage :: attrSet -> str -> package
  serviceServiceHandlerPackage =
    config: serviceHandlerName:
    lib.attrByPath [
      ns
      "network"
      "serviceHandlers"
      serviceHandlerName
      "package"
    ] null config;

  # serviceServiceHandler :: attrSet -> str -> attrSet
  serviceServiceHandler =
    config: serviceName: serviceHandler config (serviceServiceHandlerName config serviceName);
in
{
  inherit
    domainName
    netDevice
    lanIpv4
    serviceHandler
    serviceHandlerMainPort
    serviceHandlerNamedPort
    serviceHandlerHost
    serviceHandlerFQDN
    serviceHostName
    serviceDomainName
    serviceFQDN
    serviceServiceHandlerName
    serviceServiceHandlerPackage
    ;
}
