{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) enabled;
in
{
  imports = [
    ./boot.nix
    ./disko.nix
    ./hardware.nix
    ./networking.nix

    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      media = {
        jellyfin = enabled;
      };

      role = {
        log_server = enabled;
        server = enabled;
      };

      service = {
        mongodb = enabled;
        nextcloud = enabled;
        postgresql = enabled;
      };

      shell.zsh = enabled;

      theme = {
        stylix = enabled;
      };
    };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
