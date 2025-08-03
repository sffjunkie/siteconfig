{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  config = {
    programs.home-manager = enabled;

    home = {
      username = "nixos";
      # homeDirectory = lib.mkForce "/home/nixos";
      stateVersion = "23.05";
      file = {
        ".sops.yaml".source = ../../../../.sops.yaml;
        "Justfile".source = ../../../installer/Justfile;
      };
    };
  };
}
