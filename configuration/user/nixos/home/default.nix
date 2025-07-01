{ lib, ... }:
let
  inherit (lib) enabled;
in
{
  config = {
    programs.home-manager = enabled;

    home = {
      username = "nixos";
      homeDirectory = "/home/nixos";
      stateVersion = "23.05";
      file = {
        ".sops.yaml".source = ../../../../.sops.yaml;
      };
    };
  };
}
