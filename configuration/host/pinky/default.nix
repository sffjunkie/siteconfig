{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./boot.nix
    ./fs.nix
    ./hardware.nix
    ./networking.nix
    ./service

    ../common
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    looniversity = {
      service.lldap.enable = true;

      theme = {
        stylix.enable = true;
      };
    };

    programs.zsh = {
      enable = true;
      loginShellInit = ''
        # do not glob # as it conflicts with nix flakes
        disable -p '#'
      '';
    };

    environment.localBinInPath = true;

    system.stateVersion = "23.05";
  };
}
