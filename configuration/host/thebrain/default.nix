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
        graylog = {
          enable = true;
          extraConfig = "http_bind_address = 127.0.0.1:9011";
          elasticsearchHosts = [ "http://localhost:9200" ];
        };
        mongodb.enable = true;
        nextcloud.enable = true;
        postgresql.enable = true;
      };

      role = {
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
