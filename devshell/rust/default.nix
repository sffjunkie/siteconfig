{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs.buildPackages; [
    rustc
    rustfmt
    cargo
  ];

  shellHook = ''
    export CARGO_HOME="$HOME/.local/share/cargo/";
  '';
}
