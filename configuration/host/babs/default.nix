{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) enabled;
in
{
  imports = [
    ./backup.nix
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix
    ./services

    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      network = {
        tool.cli = enabled;
      };

      fs = {
        nfs = {
          exports = [
            {
              path = "/tank0/backup";
              description = "Backup";
            }
            {
              path = "/tank0/music";
              description = "Music";
            }
            {
              path = "/tank1/movies";
              description = "Movies";
            }
            {
              path = "/tank1/private";
              description = "Private";
            }
            {
              path = "/tank1/tv_shows";
              description = "TV Shows";
            }
          ];
          clients = "${toString config.looniversity.network.networkAddress}/${toString config.looniversity.network.prefixLength}";
          opts = [
            "insecure"
            "no_subtree_check"
            "rw"
            "sync"
          ];
        };
        cifs = {
          shares = [
            {
              name = "music";
              path = "/tank0/music";
              description = "Music";
            }
            {
              name = "private";
              path = "/tank1/private";
              description = "Private";
            }
          ];
          opts = {
            "read only" = "yes";
            "browseable" = "yes";
            "guest ok" = "yes";
          };
        };
      };

      storage = {
        minio = {
          enable = true;
          dataDir = [ "/tank0/minio/data" ];
        };
      };

      theme = {
        stylix = enabled;
      };

      role = {
        server = enabled;
      };
    };

    programs.zsh = enabled;

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
