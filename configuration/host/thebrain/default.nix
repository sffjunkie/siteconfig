{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix

    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      service = {
        mongodb.enable = true;
        nextcloud.enable = true;
        postgresql.enable = true;
      };

      role = {
        log_server.enable = true;
        server.enable = true;
        vm_host.enable = true;
      };

      theme = {
        stylix.enable = true;
      };
    };

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
