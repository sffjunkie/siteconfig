{
  lib,
  inputs,
  ns,
  ...
}:
final: prev: {
  enabled = {
    enable = true;
  };
  disabled = {
    enable = false;
  };

  deploy = import ./deploy.nix { inherit lib ns inputs; };
  ipv4 = import ./ipv4.nix { inherit lib ns; };
  network = import ./network.nix { inherit lib ns; };
  tool = import ./tool.nix { inherit lib ns; };
  test = import ./test.nix { inherit lib ns; };
}
