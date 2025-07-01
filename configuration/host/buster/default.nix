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
    ./fs.nix
    ./hardware.nix
    ./networking.nix

    ../common
  ];

  config = {
    # Added for Obsidian
    nixpkgs = {
      hostPlatform = lib.mkDefault "x86_64-linux";
    };

    looniversity = {
      media = {
        pavucontrol = enabled;
        spotify = enabled;
      };

      # TODO: Disable until secrets added to Sops
      network = {
        service.openvpn.enable = false;
      };

      role = {
        laptop = enabled;
        vm_host = enabled;
      };

      shell.zsh = enabled;

      storage.udisks2 = enabled;

      theme = {
        nord = enabled;
        papirus = enabled;
        stylix = enabled;
      };
    };

    environment.systemPackages = [
      pkgs.teams-for-linux
      pkgs.zoom-us
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    environment.localBinInPath = true;

    system.stateVersion = "23.05";
  };
}
