{ lib, ... }:
[
  {
    name = "ipv4.ipv4Octets";
    actual = lib.ipv4.ipv4Octets "192.168.1.1";
    expected = [
      192
      168
      1
      1
    ];
  }
  {
    name = "ipv4.ipv4Octets too long";
    actual = lib.ipv4.ipv4Octets "192.168.1.1.2";
    expected = [
      192
      168
      1
      1
    ];
  }
  {
    name = "ipv4.ipv4Address";
    actual = lib.ipv4.ipv4Address [
      192
      168
      1
      1
    ];
    expected = "192.168.1.1";
  }
  {
    name = "ipv4.ipv4IsValid";
    actual = lib.ipv4.ipv4IsValid "192.168.1.1";
    expected = true;
  }
  {
    name = "not ipv4.ipv4IsValid";
    actual = lib.ipv4.ipv4IsValid "192.168.256.1";
    expected = false;
  }
  {
    name = "ipv4.ipv4IsPrivate24BitBlock";
    actual = lib.ipv4.ipv4IsPrivate24BitBlock "10.1.1.1";
    expected = true;
  }
  {
    name = "not ipv4.ipv4IsPrivate24BitBlock";
    actual = lib.ipv4.ipv4IsPrivate24BitBlock "11.1.1.1";
    expected = false;
  }
  {
    name = "ipv4.ipv4IsPrivate20BitBlock Start Of Range";
    actual = lib.ipv4.ipv4IsPrivate20BitBlock "172.16.0.1";
    expected = true;
  }
  {
    name = "ipv4.ipv4IsPrivate20BitBlock End Of Range";
    actual = lib.ipv4.ipv4IsPrivate20BitBlock "172.31.255.255";
    expected = true;
  }
  {
    name = "not ipv4.ipv4IsPrivate20BitBlock";
    actual = lib.ipv4.ipv4IsPrivate20BitBlock "172.32.0.1";
    expected = false;
  }
  {
    name = "ipv4.ipv4IsPrivate16BitBlock";
    actual = lib.ipv4.ipv4IsPrivate16BitBlock "192.168.0.1";
    expected = true;
  }
  {
    name = "not ipv4.ipv4IsPrivate16BitBlock";
    actual = lib.ipv4.ipv4IsPrivate16BitBlock "192.169.0.1";
    expected = false;
  }
  {
    name = "ipv4.constructIpv4Address 1 octet";
    actual = lib.ipv4.constructIpv4Address "192.168.0.0" "255";
    expected = "192.168.0.255";
  }
  {
    name = "ipv4.constructIpv4Address 2 octets";
    actual = lib.ipv4.constructIpv4Address "192.168.0.0" "1.255";
    expected = "192.168.1.255";
  }
  {
    name = "ipv4.constructIpv4Address 3 octets";
    actual = lib.ipv4.constructIpv4Address "192.168.0.0" "2.1.255";
    expected = "192.2.1.255";
  }
  {
    name = "ipv4.constructIpv4Address 4 octets";
    actual = lib.ipv4.constructIpv4Address "192.168.0.0" "10.2.1.255";
    expected = "10.2.1.255";
  }
  {
    name = "ipv4.constructIpv4Address 5 octets";
    actual = lib.ipv4.constructIpv4Address "192.168.0.0" "10.2.1.255.4";
    expected = "10.2.1.255";
  }
]
