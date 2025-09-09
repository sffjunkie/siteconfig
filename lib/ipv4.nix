{
  lib,
  ns,
  ...
}:
let
  # ipv4Octets = str -> list[int]
  # Convert an IPv4 address into a list of octets.
  # Only returns the first four octets
  ipv4Octets = ipv4: lib.sublist 0 4 (map lib.toIntBase10 (lib.splitString "." ipv4));

  # ipv4Address = list[int] -> str
  # Constructs a valid IPv4 address from a list of octets
  ipv4Address = octets: lib.concatMapStringsSep "." toString (lib.sublist 0 4 octets);

  # ipv4IsValid = str -> bool
  # Retuirn tru if the address is a valid IPv4 address
  ipv4IsValid =
    ipv4:
    let
      octets = ipv4Octets ipv4;
    in
    (lib.length octets == 4) && (builtins.all (item: item < 256) octets);

  # ipv4IsPrivate24BitBlock = str -> bool
  # Returns true if the IPv4 address is part of
  # the 24 bit '10' private address block.
  ipv4IsPrivate24BitBlock =
    ipv4:
    let
      octets = ipv4Octets ipv4;
    in
    ipv4IsValid ipv4 && (lib.elemAt octets 0) == 10;

  # ipv4IsPrivate20BitBlock = str -> bool
  # Returns true if the IPv4 address is part of
  # the 20 bit '172.16' to '172.31' private address block.
  ipv4IsPrivate20BitBlock =
    ipv4:
    let
      octets = ipv4Octets ipv4;
      part1 = lib.elemAt octets 1;
    in
    ipv4IsValid ipv4 && (lib.elemAt octets 0) == 172 && (part1 >= 16 && part1 <= 31);

  # ipv4IsPrivate16BitBlock = str -> bool
  # Returns true if the IPv4 address is part of
  # the 16 bit '192.168' private address block.
  ipv4IsPrivate16BitBlock =
    ipv4:
    let
      octets = ipv4Octets ipv4;
    in
    ipv4IsValid ipv4 && (lib.elemAt octets 0) == 192 && (lib.elemAt octets 1) == 168;

  # constructIpv4Address = str -> str -> str
  # Constructs an IPv4 address from a network and a host
  # `network` is a full 4 octet network address
  # `host` is a mltui-octet host part
  #
  # e.g. constructIpv4Address "192.168.0.0" "12.13" returns "192.168.12.13"
  constructIpv4Address =
    network: host:
    let
      hostOctets = ipv4Octets host;
      networkOctets = ipv4Octets network;
      length = (lib.length networkOctets) - (lib.length hostOctets);
      octets = (lib.sublist 0 length networkOctets) ++ hostOctets;

      addr = ipv4Address octets;
    in
    addr;
in
{
  inherit
    ipv4Octets
    ipv4Address
    ipv4IsValid
    ipv4IsPrivate24BitBlock
    ipv4IsPrivate20BitBlock
    ipv4IsPrivate16BitBlock
    constructIpv4Address
    ;
}
