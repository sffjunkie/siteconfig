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

    ./settings

    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      home-automation = {
        mosquitto = enabled;
        # zigbee2mqtt = enabled;
      };

      media = {
        jellyfin = enabled;
      };

      role = {
        log_server = enabled;
        server = enabled;
      };

      db = {
        mongodb = enabled;
        postgresql = enabled;
      };

      monitoring = {
        alloy = enabled // {
          node = "thebrain";
        };
      };

      service = {
        immich = enabled;
        netbox = disabled;
        nextcloud = disabled;
      };

      shell.zsh = enabled;

      theme = {
        stylix = enabled;
      };
    };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
