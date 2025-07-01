{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  config = {
    looniversity = {
      system.age = enabled;
      system.sops = enabled;
    };
  };
}
