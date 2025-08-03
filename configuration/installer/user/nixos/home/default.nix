{ lib, ... }:
let
  ageKeyFile = "/home/sdk/.config/sops/age/keys.txt";

  inherit (lib) enabled;
in
{
  config = {
    home = {
      homeDirectory = lib.mkForce "/home/nixos";

      file = {
        ".sops.yaml".source = ../../../../../.sops.yaml;
        "Justfile".source = ../../../Justfile;
      };

      stateVersion = "23.05";

      username = "nixos";
    };

    programs.home-manager = enabled;
  };
}
