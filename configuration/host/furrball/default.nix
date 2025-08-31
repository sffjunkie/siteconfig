{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) disabled enabled;
in
{
  imports = [
    ./boot.nix
    ./backup.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix

    ./settings

    ../common
  ];

  config = {
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
    };

    looniversity = {
      admin = {
        mongodb = enabled;
        postgresql = enabled;
      };

      deploy = {
        nixos-anywhere = enabled;
      };

      doc = {
        mystmd = enabled;
      };

      keyboard.input-remapper = disabled;

      media = {
        pavucontrol = enabled;
        spotify = enabled;
      };

      mount = {
        backup = enabled;
        movies = enabled;
        music = enabled;
        private = enabled;
      };

      network = {
        tool = {
          cli = enabled;
        };
      };

      role = {
        container_host = enabled;
        games_machine = enabled;
        podcaster = enabled;
        vm_host = enabled;
        workstation = enabled;
      };

      script.wake = enabled;

      service = {
        immich = disabled;
        netbox = enabled;
      };

      shell.zsh = enabled;

      storage = {
        udisks2 = enabled;
        zfs.autoscrub = enabled;
      };

      system = {
        rclone = enabled;
      };

      theme = {
        stylix = enabled;
      };
    };

    environment.systemPackages = [
      pkgs.teams-for-linux
      pkgs.zoom-us
    ];

    systemd.services = {
      "rclone@gdrive" = {
        wantedBy = [ "default.target" ];
      };
      "rclone@onedrive" = {
        wantedBy = [ "default.target" ];
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.localBinInPath = true;

    system.stateVersion = "23.05"; # Did you read the comment?
  };
}
