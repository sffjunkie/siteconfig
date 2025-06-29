# nixos/modules/services/networking/nat.nix
{
  config,
  lib,
  ...
}:
let
  wanDev = lib.network.netDevice config "pinky" "wan";
  lanDev = lib.network.netDevice config "pinky" "lan";
in
{
  config = {
    networking.nat = {
      enable = true;
      externalInterface = wanDev;
      internalInterfaces = [ lanDev ];
    };
  };
}
