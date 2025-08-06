{
  config,
  lib,
  pkgs,
  ...
}:
let
  script = pkgs.writeScriptBin "nfu" ''
    #!${lib.getExe pkgs.bash}
    nix flake update
  '';
in
script
