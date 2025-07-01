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
      service.lldap = enabled;

      theme = {
        stylix = enabled;
      };

      shell.zsh = enabled;
    };

    environment.localBinInPath = true;

    system.stateVersion = "23.05";
  };
}
