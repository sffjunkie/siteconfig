{
  config,
  lib,
  pkgs,
  tmpDir ? "/var/tmp/nixos-rebuild",
  ...
}:
let
  nixosScriptGenerations = pkgs.callPackage ./generations.nix { };
  nixosScriptInstaller = pkgs.callPackage ./installer.nix { };
  nixosScriptSystem = pkgs.callPackage ./system.nix { inherit tmpDir; };
  nixosScriptUnittest = pkgs.callPackage ./unittest.nix { };
  nixosScriptVm = pkgs.callPackage ./vm.nix { };
in
[
  nixosScriptGenerations
  nixosScriptInstaller
  nixosScriptSystem
  nixosScriptUnittest
  nixosScriptVm
]
