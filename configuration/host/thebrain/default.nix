{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) disabled enabled;
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
        nextcloud = disabled;
        postgresql = disabled;
      };

      shell.zsh = enabled;

      theme = {
        stylix = enabled;
      };
    };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
