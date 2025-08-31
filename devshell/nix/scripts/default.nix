{
  config,
  lib,
  pkgs,
  tmpDir ? "/var/tmp/nixos-rebuild",
  ...
}:
let
  nixosScriptDeploy = pkgs.callPackage ./deploy.nix { };
  nixosScriptFlakeUpdate = pkgs.callPackage ./nfu.nix { };
  nixosScriptGenerations = pkgs.callPackage ./generations.nix { };
  nixosScriptInstaller = pkgs.callPackage ./installer.nix { };
  nixosScriptSystem = pkgs.callPackage ./system.nix { inherit tmpDir; };
  nixosScriptUnittest = pkgs.callPackage ./unittest.nix { };
  nixosScriptVm = pkgs.callPackage ./vm.nix { };
in
[
  nixosScriptDeploy
  nixosScriptFlakeUpdate
  nixosScriptGenerations
  nixosScriptInstaller
  nixosScriptSystem
  nixosScriptUnittest
  nixosScriptVm
]
