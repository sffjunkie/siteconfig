{ pkgs, ... }:
let
  tmpDir = "/var/tmp/nixos-rebuild";
  nixosScripts = pkgs.callPackage ./scripts { inherit tmpDir; };
in
pkgs.mkShell {
  buildInputs = [
    pkgs.jq
    pkgs.nh
    pkgs.nix-info
    pkgs.nix-output-monitor
    pkgs.nix-template
    pkgs.nix-tree
    pkgs.nix-update
    pkgs.nixfmt-rfc-style
    pkgs.nixpkgs-review
    pkgs.node2nix
    pkgs.nvd
    pkgs.treefmt
  ]
  ++ nixosScripts;
}
